<?php
App::uses('MustacheStringView', 'MustacheCake.View','CakeEmail');

class MailsController extends AppController{
    var $uses=array('Mail','Encuesta','EncuestaGrupos','EncuestaUsuarios','VistaCantUsuariosEnc','Grupo','Usuario','GruposUsuarios','VistaMail','VistaRecordatorio','VistaMailDcRecordatorio');

    public $ext = '.mustache';
    public $viewClass = 'MustacheCake.Mustache';

	function beforeFilter() {
            parent::beforeFilter();
            $sesion=$this->Session->Read();
            //debug($sesion);
            if($sesion['OUsuario']==null){

                $this->Session->setFlash("Debe loguearse para acceder a esta sección.<br>"
                            . "               El administrador ha sido notificado del error",null,null,"mensaje_sistema");
                $this->redirect(array('controller'=>'pages','action'=>'display','inicio'));
            }

        }

        function crear(){
            $tipoMail =array('1'=>'Encuesta','2'=>'Datos de Contacto');
            $tipoEnvio=array('1'=>'Envío por primera vez','2'=>'Recordatorio');
            $encuestas=$this->Mail->Encuesta->find("list");
            $this->set("tipoMail",$tipoMail);
            $this->set('tipoEnvio',$tipoEnvio);
            $this->set("encuestas",$encuestas);
        }

    	function enviar(){
    		$this->autoRender = false;
    		$Email = new CakeEmail();



                $grupos		 = $this->request->data["Grupos"];
        	$encuesta_id = $this->request->data["Mail"]["encuesta_id"];
        	$tipoEnvio   = $this->request->data["Mail"]["tipoEnvio"];
        	$enviados=array();
        	$sin_enviar=array();


        	//Si es una encuesta a enviar --> Si trae el id de la encuesta entra
        	if ($encuesta_id !=false){
           	 switch ($tipoEnvio){
           	     case 1: //Envío por primera vez
           	     	    //Recorro los grupos que seleccionaron
                            foreach($grupos as $grupo_id){

           	     	   		$this->Mail->Encuesta->Grupos->Behaviors->load('Containable');
                                        $tmpUsuarios = $this->Mail->Encuesta->Grupos->find("first",array("conditions"=>array("Grupos.id"=>$grupo_id),"contain"=>array("Usuarios"=>array("limit"=>4))));
                            foreach($tmpUsuarios["Usuarios"] as $tmpUsuario){
                                //pr($tmpUsuario);
                                $Template = new MustacheStringView();
                                $Template->layout = false;
                                $Email->reset();
                                //$Template->start($tmpUsuario["usuario"]);
                                $Email->config('gmail');
                                //$Email->transport('Debug');
                                $Email->from(array('youremail@lala.com' => 'Test'));
                                //$Email->to($tmpUsuario["email_1"]);
                                $Email->to('youremail@lala.com');
                           	$Email->subject($this->request->data['Mail']['asunto']);
                            	$Template->set("usuario",$tmpUsuario["usuario"]);
                            	$Template->set("nombre",$tmpUsuario["nombre"]);
                            	$Template->set("apellido",$tmpUsuario["apellido"]);
                            	$Template->set("dni",$tmpUsuario["dni"]);
                                $out = $Template->render($this->request->data["Mail"]["mensaje"]);
                            	$Email->emailFormat("html");
                            //Quiere decir que mando todo ok
                            if ($Email->send($out)) {
                            	$enviados[$grupo_id][]   = $tmpUsuario["id"];
                            } else {
                            	$sin_enviar[$grupo_id][] = $tmpUsuario["id"];
                            }

                            } // end foreach Usuarios
                        } // END FOREACH GRUPOS
						// BUSCO LOS DATOS DE USUARIOS PARA EL RESUMEN DE ENVIO DE EMAILS


                        // AGRUPO TODOS LOS USUARIO_ID PARA GUARDAR LUEGO EN LA RELACION MAIL->USUARIOS HASANDBELONGSTOMANY
                        // SE LE PASA UN SEGUNDO PARAMETRO QUE ES EL ESTADO 1->ENVIADO 2->NO-ENVIADO
                        $usuarios = array();
                        foreach($enviados as $grupo_id=>$nada){
                    		$usuarios = array_merge($usuarios,$enviados[$grupo_id]); // HACIENDO UN ARRAY_MERGE SACO LOS POSIBLES USUARIOS REPETIDOS EN LOS GRUPOS AGREGADOS
                    	}

                    	// UNA VEZ PROCESADO TODOS LOS USUARIO_ID LOS GUARDO EN $THIS->DATA PARA LUEGO PASARLO AL PARAMETRO SAVE
                    	foreach($usuarios as $usuario_id){
                    		$this->request->data["Usuarios"][$usuario_id] = array("usuario_id"=>$usuario_id,"estado"=>1);
                    	}
                    	// MISMO CODIGO DE ARRIBA PERO AGRUPO SOLO LOS QUE NO FUERON ENVIADOS
                    	$usuarios = array();
                    	foreach($sin_enviar as $grupo_id=>$nada){
                    		$usuarios = array_merge($usuarios,$sin_enviar[$grupo_id]);
                    	}
                    	foreach($usuarios as $usuario_id){
                    		$this->request->data["Usuarios"][$usuario_id] = array("usuario_id"=>$usuario_id,"estado"=>2);
                    	}

                    	// GUARDO EL NUEVO EMAIL Y SUS CORRESPONDIENTES RELACIONES
                    	if($this->Mail->save($this->data)){
                    		$this->Session->setFlash("Email enviado con exito",null,null,"mensaje_sistema");
                    	}else{
                    		$this->Session->setFlash("Ocurrio un error al intentar guardar ");
                    	}
                        //busco el nombre del grupo:
                        if(!empty($enviados)){
                            foreach($enviados as $id_grupo=>$id_usuario){
                                $nombre_grupo=$this->Grupo->find('list',array('conditions'=>array('Grupo.id'=>$id_grupo)));
                                $nombre_usuarios=$this->Usuario->find('list',array('conditions'=>array('Usuario.id'=>$id_usuario),'fields'=>array('Usuario.email_1')));
                             }
                            $this->set("nombre_grupo",$nombre_grupo);
                            $this->set("nombre_usuarios",$nombre_usuarios);

                        }
                        if(!empty($sin_enviar)){
                            foreach($sin_enviar as $id_grupo=>$id_usuario){
                                $usuario_sin_enviar=$this->Usuario->find('list',array('conditions'=>array('Usuario.id'=>$id_usuario)));
                            }
                            $this->set("usuario_sin_enviar",$usuario_sin_enviar);
                        }
                    	$this->set("Enviados",$enviados);
                    	$this->set("SinEnviar",$sin_enviar);

                    	$this -> render('/Mails/resultados');
                    	break; //TERMINA CASE DE ENVÍO POR PRIMERA VEZ

                /* Recordatorio -->Todos los usuarios que no hayan completado la encuesta
                 * Mandar mail a los usuarios que tienen menos del 90% (rango de 0 a 90)
                 * completada la encuesta */
                case '2':
                		foreach($grupos as $grupo_id){
                        	/*Traigo los usuarios de las encuestas que el porcentaje sea menor al 90 %
                        	*Son a todos los usuarios que se les ha enviado el mail pero no respondieron
                        	* o les falta completar. */
                        	$condiciones = array("ResumenUsuario.encuesta_id"=>$encuesta_id,
                        			     "ResumenUsuario.grupo_id"=>$grupo_id,
                        			     "ResumenUsuario.porcentaje <="=>"90");
                        	$tmpUsuarios = $this->Mail->Usuarios->ResumenUsuario->find('all',array("conditions"=>$condiciones,"contain"=>array("Usuario")));
                                //pr($tmpUsuarios);
                                foreach($tmpUsuarios as $usuariost){

                                       pr($usuariost['Usuario']['usuario']);
                                        $Email->to('youremail@lala.com');
                       			$Email->emailFormat("html");
                        		$Email->subject($this->request->data['Mail']['asunto']);
                        		$Template->set("usuario",$usuariost['Usuario']["usuario"]);
                        		$Template->set("nombre",$usuariost['Usuario']["nombre"]);
                        		$Template->set("apellido",$usuariost['Usuario']["apellido"]);
                        		$Template->set("dni",$usuariost['Usuario']["dni"]);
                        		$out = $Template->render($this->request->data["Mail"]["mensaje"]);
                                        pr($out);
                                        /*if ($Email->send($out)) {
                        			$enviados[$grupo_id][]   = $usuariost['Usuario']["id"];
                        		} else {
                        			$sin_enviar[$grupo_id][] = $usuariost['Usuario']["id"];
                        		}*/
                                }
                                }
                		// AGRUPO TODOS LOS USUARIO_ID PARA GUARDAR LUEGO EN LA RELACION MAIL->USUARIOS HASANDBELONGSTOMANY
                		// SE LE PASA UN SEGUNDO PARAMETRO QUE ES EL ESTADO 1->ENVIADO 2->NO-ENVIADO
                		$usuarios = array();
                		foreach($enviados as $grupo_id=>$nada){
                			$usuarios = array_merge($usuarios,$enviados[$grupo_id]); // HACIENDO UN ARRAY_MERGE SACO LOS POSIBLES USUARIOS REPETIDOS EN LOS GRUPOS AGREGADOS
                		}

                		// UNA VEZ PROCESADO TODOS LOS USUARIO_ID LOS GUARDO EN $THIS->DATA PARA LUEGO PASARLO AL PARAMETRO SAVE
                		foreach($usuarios as $usuario_id){
                			$this->request->data["Usuarios"][$usuario_id] = array("usuario_id"=>$usuario_id,"estado"=>1);
                		}
                		// MISMO CODIGO DE ARRIBA PERO AGRUPO SOLO LOS QUE NO FUERON ENVIADOS
                		$usuarios = array();
                		foreach($sin_enviar as $grupo_id=>$nada){
                			$usuarios = array_merge($usuarios,$sin_enviar[$grupo_id]);
                		}
                		foreach($usuarios as $usuario_id){
                			$this->request->data["Usuarios"][$usuario_id] = array("usuario_id"=>$usuario_id,"estado"=>2);
                		}

                		// GUARDO EL NUEVO EMAIL Y SUS CORRESPONDIENTES RELACIONES
                		if($this->Mail->save($this->data)){
                			$this->Session->setFlash("Email enviado con exito",null,null,"mensaje_sistema");
                		}else{
                			$this->Session->setFlash("Ocurrio un error al intentar guardar ");
                		}
                                if(!empty($enviados)){
                            foreach($enviados as $id_grupo=>$id_usuario){
                                $nombre_grupo=$this->Grupo->find('list',array('conditions'=>array('Grupo.id'=>$id_grupo)));
                                $nombre_usuarios=$this->Usuario->find('list',array('conditions'=>array('Usuario.id'=>$id_usuario),'fields'=>array('Usuario.email_1')));
                             }
                            $this->set("nombre_grupo",$nombre_grupo);
                            $this->set("nombre_usuarios",$nombre_usuarios);

                        }
                        if(!empty($sin_enviar)){
                            foreach($sin_enviar as $id_grupo=>$id_usuario){
                                $usuario_sin_enviar=$this->Usuario->find('list',array('conditions'=>array('Usuario.id'=>$id_usuario)));
                            }
                            $this->set("usuario_sin_enviar",$usuario_sin_enviar);
                        }
                    	$this->set("Enviados",$enviados);
                    	$this->set("SinEnviar",$sin_enviar);

                    	$this -> render('/Mails/resultados');

                    break; //Termina Case de Recordatorio.


                            }
        } // END IF ENCUESTA_ID NO ES FALSO
        //Si es para que completen los datos del contacto
        /*
        if($id_encuesta==false && !empty($grupos)){
            switch ($tipo_envio){
                case '1':
                    //Envío por primera vez
                     //Usuario que completó la encuesta pero que
                     //no completó los datos de contacto
                    foreach($grupos as $id_cake=>$id_grupo):
                       //Traigo los usuarios de las encuestas que el porcentaje sea menor al 90 %
                         //*Son a todos los usuarios que se les ha enviado el mail pero no respondieron
                         //* o les falta completar.
                        $datos=$this->VistaMailDcRecordatorio->find('all',array('conditions'=>array('VistaMailDcRecordatorio.grupo_id'=>$id_grupo)));
                        //pr($datos);
                            foreach($datos as $usuario):
                                //Acá estoy trayendo todos los datos de el usuario
                                //que paso por la condición del grupo y de la encuesta
                                //No existe en la tabla mail
                                //pr($usuario);
                                $this->Email->reset();
                                $this->Email->from='elpitialvarez@gmail.com';
                                //$this->Email->to=$usuario['VistaMail']['email_1'];
                                //$this->Email->to='esunapruebaigual@outlook.com';

                                $this->Email->sendAs   = 'html';
                                //Quiere decir que mando todo ok
                                if ($this->Email->send('body')) {
                                    $temp_mail['Mail']['id']=$usuario['VistaRecordatorio']['id'];
                                    $temp_mail['Mail']['grupo_id']=$usuario['VistaRecordatorio']['grupo_id'];
                                    $temp_mail['Mail']['encuesta_id']=$usuario['VistaRecordatorio']['encuesta_id'];
                                    $temp_mail['Mail']['usuario_id']=$usuario['VistaRecordatorio']['usuario_id'];
                                    $temp_mail['Mail']['tipo_envio']=2;
                                    $this->Mail->save($temp_mail);
                                    $enviados[]=$usuario;
                                } else {
                                    $sin_enviar[]=$usuario;
                                }
                            endforeach;
                    endforeach;
                    break;
                case '2':
                    //Recordatorio de completar datos
                    //Usuario que no modificó sus datos
                    //los últimos 6 meses
                    foreach($grupos as $id_cake=>$id_grupo):
                    //pr($id_grupo);
                        //Traigo los usuarios de las encuestas que el porcentaje sea menor al 90 %
                         //Son a todos los usuarios que se les ha enviado el mail pero no respondieron
                         // o les falta completar.
                        $datos=$this->VistaMailDcRecordatorio->find('all',array('conditions'=>array('VistaMailDcRecordatorio.grupo_id'=>$id_grupo)));
                        //pr($datos);
                            foreach($datos as $usuario):
                                //Acá estoy trayendo todos los datos de el usuario
                                //que paso por la condición del grupo y de la encuesta
                                //No existe en la tabla mail
                                //pr($usuario);
                                $this->Email->reset();
                                $this->Email->from='elpitialvarez@gmail.com';
                                //$this->Email->to=$usuario['VistaMail']['email_1'];
                                //$this->Email->to='esunapruebaigual@outlook.com';

                                $this->Email->sendAs   = 'html';
                                //Quiere decir que mando todo ok
                                if ($this->Email->send('body')) {
                                    $temp_mail['Mail']['id']=$usuario['VistaRecordatorio']['id'];
                                    $temp_mail['Mail']['grupo_id']=$usuario['VistaRecordatorio']['grupo_id'];
                                    $temp_mail['Mail']['encuesta_id']=$usuario['VistaRecordatorio']['encuesta_id'];
                                    $temp_mail['Mail']['usuario_id']=$usuario['VistaRecordatorio']['usuario_id'];
                                    $temp_mail['Mail']['tipo_envio']=2;
                                    $this->Mail->save($temp_mail);
                                    $enviados[]=$usuario;
                                } else {
                                    $sin_enviar[]=$usuario;
                                }
                            endforeach;
                    endforeach;
                    break;
            }

        }*/


    }

}
?>
