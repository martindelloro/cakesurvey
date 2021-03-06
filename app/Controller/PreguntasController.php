<?php

class PreguntasController extends AppController{
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
	function listar($modo = null){
		$this->paginate = array(
				"order"=>"Pregunta.nombre ASC",
				'recursive' => 0,
				'limit'=>"20"
		);
		$this->set("preguntas",$this->paginate("Pregunta"));
		if($modo == "seleccionar") $this->render("/Elements/Preguntas/seleccionar/listar");
	}
	
	function buscar(){
		$this->paginate = array("order"=>"Pregunta.nombre ASC",'recursive' => 0);
                
                if(!empty($this->request->data)){
                    $condiciones=null;
                    if(!empty($this->request->data["Buscar"]["nombre"])) $condiciones["Pregunta.nombre ILIKE"]="%".$this->request->data["Buscar"]["nombre"]."%";
                    $this->Session->write("busqueda", $condiciones);
                    $this->set("preguntas",$this->Paginator->paginate("Pregunta"));
                }else{
                    
			$this->request->data = $this->Session->read("busqueda");
                        pr("bolsa de guampa");
		}
                $this->Paginator->settings = array("conditions"=>$condiciones);
		$this->set("preguntas",$this->Paginator->paginate("Pregunta"));
	}
	
	function crear(){
		$tipos  = $this->Pregunta->Tipo->find("list");
		$reglas = $this->Pregunta->Validacion->Regla->find("list"); 
		if(!empty($this->data)){

			/*if($this->Pregunta->save($this->request->data)){
				$pregunta = $this->Pregunta->find("first",array("conditions"=>array("Pregunta.id"=>$this->Pregunta->getInsertId())));*/

			if($this->Pregunta->save($this->data)){
				$pregunta = $this->Pregunta->find("first",array("conditions"=>array("Pregunta.id"=>$this->Pregunta->getInsertId()),"contain"=>array("Encuesta","Tipo")));

				$this->set("pregunta",$pregunta);
				$this->Session->setFlash("Pregunta agregada con exito",null,null,"mensaje_sistema");
				$this->render("agregarMenu");			
			}
			else{
				$this->Session->setFlash("Ocurrio un error al intentar guardar la pregunta",null,null,"mensaje_sistema");
			}
			
		}else{
			
			
		}
		$this->set("tipos",$tipos);
		$this->set("reglas",$reglas);
	}
	
}


?>