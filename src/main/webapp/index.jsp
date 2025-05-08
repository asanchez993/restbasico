<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Rest Basico</title>
<script type="text/javascript" src="js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
	
		//Esta funci�n a�ade un elemento a la lista de usuarios. 
		function load(id,name,surname){
			//Crea el nuevo elemento 'li' que contendr� los datos del usuario.
			var entry = document.createElement('li');
			
			//Crea un elemento que ser� el enlace para borrar el usuario creado.
			var a = document.createElement('a');
			//Se a�ade el evento que se ejecutar� al hacer clic sobre borrar.
			a.onclick = function () {
				$.ajax({
				    url: 'rest/persona/borra/' + id, //Url a ejecutar
				    type: 'DELETE', //M�todo a invocar
				    dataType: "json", //Tipo de dato enviado
				    success: function(result) {
				    	//Funci�n que se ejecuta si todo ha ido bien. En este caso, quitar el <li> que se cre� para mostrar
				    	//el usuario insertado.
				    	document.getElementById(id).remove();
				    },
			    	error: function(jqXhr, textStatus, errorMessage){
				    	alert('error');	
				    }
				});
			};
			
			
			var aEditar = document.createElement("a");
			//Texto del enlace para borrar el usuario
			var linkText = document.createTextNode(" [Borrar]");
			var linkTextEditar = document.createTextNode(" [Editar]");		
			//Se a�ade el texto a la etiqueta <a>
			a.appendChild(linkText);
			aEditar.appendChild(linkTextEditar);
			aEditar.onclick= function(){
				$.ajax({
				    url: 'rest/persona/get-persona/' + id, //Url a ejecutar
				    type: 'GET', //M�todo a invocar
				    dataType: "json", //Tipo de dato enviado
				    success: function(result) {
				    	$("#id").attr("value", result.id);
				    	$("#nombre").attr("value", result.nombre);
				    	$("#apellido1").attr("value", result.nombre);
				    	$("#apellido2").attr("value", result.nombre);
				    },
			    	error: function(jqXhr, textStatus, errorMessage){
				    	alert('error');	
				    }
				});
			}
			
			
	
			
			//Se identifica el <li> con el id del usuario creado. As� se podr� recuperar en el futuro para eliminarlo.
			entry.id = id;		
			
			//Se a�ade texto al <li>
			entry.appendChild(document.createTextNode("("+ id + ") " +name + " " + surname));
			
			//Se pone como hijo de <li> el enlace <a> creado anteriormente  
			entry.appendChild(a);
			entry.appendChild(aEditar);
			
			//Se a�ade el <li> al <ul> que hay en el cuerpo de la p�gina.
			$('#personas').append(entry);
			
		}
	
		//Cuando el documento est� cargado en el navegador se ejecuta esta funci�n.
		$(document).ready(function(){
			
			
			//Se a�ade la funci�n que se ejecutar� al hacer clic sobre el bot�n identificado por "crearUsuario"
			$("#crearUsuario").click(function(){
				
				//Se construye el JSON a enviar {"id":"valor","name":"valor","surname":"valor"}
				//no se ponen las comillas porque la funci�n JSON.stringify ya lo hace.
				var personaInfo = {id: $('#id').val(),nombre: $('#nombre').val(),apellido1: $('#apellido1').val(), apellido2: $("#apellido2").val()};
				
			    $.ajax({
			    		data: JSON.stringify(personaInfo),
					    url: 'rest/persona/alta-usuario', //URL a la que invocar					    
					    headers: { 
				               'Accept': 'application/json',
				               'Content-Type': 'application/json' 
				           },
					    type: 'POST', //M�todo del servicio rest a ejecutar
					    dataType: "json", 
					    success: function(result) {
					    	//Esta funci�n se ejecuta si la petici�n ha ido bien. El cuerpo de la respuesta HTTP
					    	//se recibe en el par�metro 'result'
					    	//Ejemplo JSON respuesta --> {"persona":{"apellido1":"Garc�a","apellido2": "S�nchez","nombre":"Juan","id":"34"}}
					    	
					    	//Se llama a la funci�n que a�ade el elemento a la lista.
					    	load(result.persona.id, result.persona.nombre, result.persona.apellido1);
					    },
				    	error: function(jqXhr, textStatus, errorMessage){
					    	alert('Error: ' + jqXhr.responseJSON.resultado);	
					    }
					    
					});
			    });
		
			
			//Se invoca la petici�n REST que devuelve todos los usuarios y se cargan dentro del <ul> de la p�gina.
			$.ajax({
			    url: 'rest/persona/todos',
			    type: 'GET',
			    dataType: "json",
			    success: function(result) {
			    	//Para cada elemento del array de result.personas se ejecuta la funci�n que se pasa como par�metro.
			    	//Esa funci�n tiene dos par�metros, i para la posici�n y val para el valor del elemento en curso.
			    	jQuery.each(result.personas, function(i, val) {
			    		  load(val.id, val.nombre, val.apellido1);
			    		});
			    }
			});
		});
</script>

</head>
<body>
<h1>Ejemplo de Rest</h1>
<br>
<a href="rest/persona/getDatosPersona">Llamada Get</a>
	Formulario para insertar un nuevo usuario.<br>
	Id:<input type=text id="id"><br>
	Nombre:<input type=text id="nombre"><br>
	Apellido1:<input type=text id="apellido1"><br>
	Apellido2:<input type=text id="apellido2"><br>
	<button id="crearUsuario">Crear</button>
	<button id="editarUsuario">Guarda Usuario Editado</button>

<br>
	Listado de usuarios creados
	<br>
	<ul id="personas"></ul>

</body>
</html>

