<?php echo $this->Html->link("<i class='icon icon-file-pdf-o'> Crear PDF</i>",array("controller"=>"subReportes","action"=>"pdf"),array("escape"=>false,"id"=>"botonPdf","class"=>"btn btn-inverse","style"=>"float:right")); ?>
<div style="clear:both"></div>
<?php if(!empty($filtrosInfo)):?>
    <div class="well label-titular color-3"> Filtros aplicados </div>
    <?php foreach($filtrosInfo as $filtroInfo): ?>
    <div class="well contenedor-filtros">
    <div class="row-fluid">
    <div class="span12"><div class="label labelPregunta">Pregunta:</div><?php echo $filtroInfo["Pregunta"]["nombre"] ?></div>
    </div>
     <div class="contenedor-opciones">
    <?php if($filtroInfo["Pregunta"]["tipo"] == "Seleccione una opcion"): ?>
    <?php foreach($filtroInfo["opciones"] as $opcion): ?>
     <div class="opcion-filtro label label-info"><?php echo $opcion ?></div>
    <?php endforeach; ?>
    <?php endif; ?>
    <?php if($filtroInfo["Pregunta"]["tipo"] == "SI/NO"): ?>
     <div class="label label-info"><?php echo $filtroInfo["boolean"]?"SI":"NO" ?></div>
    <?php endif; ?>
    </div>
    </div>
    <?php endforeach; ?>
    <?php endif; ?>
<!-- ********************************************** -->
<!-- ***** COMIENZO RESULTADOS GRAFICO BARRAS ***** -->
<!-- ********************************************** -->
<?php if(!empty($datosInfo)): ?>
<div class="well label-titular color-3">Resultados</div>
<?php foreach($datosInfo["Resultados"]["Opciones"] as $nombre=>$valor): ?>
    <div class="row-fluid resumen-resultados">
        <div class="span6 color-1 borde-1 borde-abajo"><span><?php echo ucfirst($nombre); ?></span></div>
        <div class="span6 borde-1"><span><?php echo $valor.' ('.round(($valor*100/($datosInfo["Resultados"]["total"])),1).'%)'?></span></div>
    </div>
<?php endforeach;?>
    <div class="row-fluid resumen-resultados">
        <div class="span6 color-1"><span>Total</span></div>
        <div class="span6 "><span><?php echo $datosInfo["Resultados"]["total"].' (100%)' ?></span></div>
    </div>
<div class="well label-titular color-3"><?php echo $datosInfo["Pregunta"]["nombre"] ?></div>
<?php endif; ?>
<!-- ***** FIN IF RESULTADOS GRAFICO TIPO BARRAS ***** -->
<!-- **************************************************** -->
<!-- ***** COMIENZO RESULTADOS GRAFICO STACKED BARS ***** -->
<!-- **************************************************** -->
<?php if(!empty($datosInfoStacked)): ?>
<div class="scrollTable">
    <table class="table table-striped">
        <thead>
            <tr class="preguntasTabla">
                <th><?php echo $preguntaX ?></th>
                <th colspan="<?php echo count($categoriasY)+1; ?>"><span style="width:800px;display:block"><?php echo $preguntaY ?></span></th>
            </tr>
        <tr>
        <th></th>
        <?php foreach($categoriasY as $categoriaY): ?>
            <th><?php echo ucfirst($categoriaY) ?></th>
        <?php endforeach; ?>
            <th>Total</th>
        </tr>
        </thead>
    <tbody>
        <?php foreach($datosInfoStacked as $categoriaX=>$datosY): ?>
        <tr>
            <td><?php echo ucfirst($categoriaX) ?></td>
            <?php foreach($datosY["Resultados"] as $categoriaY=>$valor): ?>
            <td><?php echo $valor.' ('.round((($valor*100)/$datosY["Total"]),1).'%)' ?></td>
            <?php endforeach; ?>
            <td><?php echo $datosY["Total"].' ('.round((($datosY["Total"]*100)/array_sum($totalesY)),1).'%)' ?></td>
        </tr>
    </tbody>
    <?php endforeach; ?>
    <tr>
        <td>Total</td>
        <?php foreach($totalesY as $totalY): ?>
        <td><?php echo $totalY ?></td>
        <?php endforeach; ?>
        <td><?php echo array_sum($totalesY).' (100%)'; ?></td>
    </tr>
    </table>
</div>
<?php endif; ?>
<!-- ***** FIN IF RESULTADOS GRAFICO STACKED BARS ***** -->
<!-- ********************************************** -->
<!-- ***** COMIENZO RESULTADOS GRAFICO DE EVOLUCIÓN ***** -->
<!-- ********************************************** -->
<?php if(!empty($datosInfoEvolucion)): ?>

<div class="scrollTable">
    <table class="table table-striped">
        <thead>
            <tr class="preguntasTabla">
                <th><?php echo $preguntaX ?></th>
                <th colspan="<?php echo count($categoriasY)+1; ?>"><span style="width:800px;display:block"><?php echo $preguntaY ?></span></th>
            </tr>
        <tr>
        <th></th>
        <?php foreach($categoriasY as $categoriaY): ?>
            <th><?php echo ucfirst($categoriaY) ?></th>
        <?php endforeach; ?>
            <th>Total</th>
        </tr>
        </thead>
    <tbody>
        <?php foreach($datosInfoEvolucion as $categoriaX=>$datosY): ?>
        <tr>
            <td><?php echo ucfirst($categoriaX) ?></td>
            <?php foreach($datosY["Resultados"] as $categoriaY=>$valor): ?>
            <td><?php echo $valor.' ('.round((($valor*100)/$datosY["Total"]),1).'%)' ?></td>
            <?php endforeach; ?>
            <td><?php echo $datosY["Total"].' ('.round((($datosY["Total"]*100)/array_sum($totalesY)),1).'%)' ?></td>
        </tr>
    </tbody>
    <?php endforeach; ?>
    <tr>
        <td>Total</td>
        <?php foreach($totalesY as $totalY): ?>
        <td><?php echo $totalY ?></td>
        <?php endforeach; ?>
        <td><?php echo array_sum($totalesY).' (100%)'; ?></td>
    </tr>
    </table>
</div>
<?php endif; ?>
<!-- ***** FIN IF RESULTADOS GRAFICO DE EVOLUCIÒN ***** -->

<?php if(isset($preguntaY)): ?>
    <div class="well label-titular color-3">
        <?php echo $preguntaY ?>
    </div>
<?php endif; ?>
    <div id="leyenda" class="leyenda" style="display:none"></div>
    <?php if($this->data["SubReporte"]["grafico_tipo"]==1 || $this->data["SubReporte"]["grafico_tipo"]==2){ ?>
            <div id="graficoBarras" class="grafico" ></div>
            
    <?php } ?>
    <?php if($this->data["SubReporte"]["grafico_tipo"]==3){ ?>
    <div id="graficoPie" class="grafico" ></div>
    <?php } ?>
    <?php if($this->data["SubReporte"]["grafico_tipo"]==4){ ?>
    <div id="graficoEvolucion" class="grafico"></div>
    
    <?php } ?>
    
<?php if(isset($preguntaX)): ?>
    <div class="well label-titular color-3">
        <?php echo $preguntaX ?>
    </div>
<?php endif; ?>
<!-- ***** FIN IF RESULTADOS GRAFICO DE TORTA ***** --><br>
<?php if(isset($fuentes)): ?>
    <div class="well label-titular color-3">
        <?php echo 'Fuente: '.$fuentes ?>
    </div>
<?php endif; ?>
<script src="http://d3js.org/d3.v3.min.js"></script>

<?php echo $this->Html->script("/js/graficos/barras.js"); ?>
<?php echo $this->Html->script("/js/graficos/stacked.js"); ?>
<?php echo $this->Html->script("/js/graficos/pie.js"); ?>
<?php echo $this->Html->script("/js/graficos/evolucion.js"); ?>

<script type="text/javascript">
$(document).ready(function(){
	var margin = {top: 20, right: 20, bottom: 80, left: 40};
	<?php if(isset($pdf)): ?>
		width = 970;
		height = 500;
		$(".leyenda").width(width);
		$(".leyenda").height(160);
	<?php endif; ?>
	<?php if(!isset($pdf)): ?>
		width = $(".grafico:first").width() - margin.left - margin.right;
		height = $(".grafico:first").height() - margin.top - margin.bottom;
	<?php endif; ?>
		
	var x = d3.scale.ordinal().rangeRoundBands([0, width], .1);
	var y = d3.scale.linear().range([height, 0]);
	var xAxis = d3.svg.axis().scale(x).orient("bottom");
	var yAxis = d3.svg.axis().scale(y).orient("left").ticks(20);
	var svg = d3.select("#graficoBarras").append("svg")
	.attr("width", width + margin.left + margin.right)
	.attr("height", height + margin.top + margin.bottom)
	.append("g");
	

	<?php if($this->data["SubReporte"]["grafico_tipo"] == 1): ?>
		datos = <?php echo json_encode(array_values($cont_opciones)); ?>;
		barras(svg,x,y,xAxis,yAxis,datos,height);
	<?php endif; ?>
	<?php if($this->data["SubReporte"]["grafico_tipo"] == 2): ?>
		datos = <?php echo json_encode($datos); ?>;
		categoriasX = <?php echo json_encode($categoriasX); ?>;
		categoriasY = <?php echo json_encode($categoriasY); ?>;
		stackedBars(x,y,xAxis,yAxis,svg,width,height,d3,categoriasY,categoriasX,datos);
	<?php endif; ?>
	<?php if($this->data["SubReporte"]["grafico_tipo"] == 3): ?>
	 	datos = <?php echo json_encode(array_values($cont_opciones)); ?>;
                contenido = <?php echo json_encode($contenido); ?>;
                torta(contenido);
	<?php endif; ?>
            <?php if($this->data["SubReporte"]["grafico_tipo"] == 4): ?>
                var svg = d3.select("#graficoEvolucion").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g");
                
		datos = <?php echo json_encode($evolucion); ?>;
                
		categoriasX = <?php echo json_encode($categoriasX); ?>;
		categoriasY = <?php echo json_encode($categoriasY); ?>;
                titulo = <?php echo json_encode($preguntaGraficoX['Pregunta']['nombre']); ?>;
                etiquetay = <?php echo json_encode($preguntaY); ?>;
		evolucion(categoriasX,categoriasY,titulo,etiquetay, datos);
	<?php endif; ?>
            

});

</script>

<script type="text/javascript">
$("#botonPdf").bind("click",function(){
	$.fileDownload($(this).prop('href'), {
	    preparingMessageHtml: "Estamos preparando su reporte, aguarde...",
	    failMessageHtml: "Ocurrio un error al intentar procesar la solicitud",
	    data:$('#ReporteGenerarForm').serialize(),
	    httpMethod:"POST"
	});
	return false;
});


</script>
