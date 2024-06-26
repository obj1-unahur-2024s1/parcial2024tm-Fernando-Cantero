
object hogwart{
	method esPeligroso(estudiante) = false
	method siguiente() = gryffindor
}

object gryffindor{
	method esPeligroso(estudiante) = true
	method siguiente() = ravenclaw
}

object ravenclaw{
	method esPeligroso(estudiante) = estudiante.esExperimentado()
	method siguiente() = hufflepuff
}

object hufflepuff{
	method esPeligroso(estudiante) = estudiante.sangrePura()
	method siguiente() = hogwart
}


class Individuo {
	var property salud
	
	method perderSalud(cant){
	 	salud = 0.max(salud - cant)
	}
	
	method aumentarSalud(cant){
		salud += cant
	}
}

class CriaturaInmune inherits Individuo{
	override method perderSalud(cant) {}
}

class Estudiante inherits Individuo{
	var property habilidad
	var property casa
	const sangrePura 
	const hechisos = #{}
	const materias = #{}
	
	method esPeligroso() = 
		if (self.salud() == 0){
			return false
		}
		else{
			return casa.esPeligroso(self)
		}
	  
	
	method sangrePura() = sangrePura
	
	method esExperimentado() = habilidad > 10
	
	method inscribirseAMateria(materia){
		if (!self.estaInscripto(materia)){
			materias.add(materia)
		}
	}
	
	method estaInscripto(materia) = materias.contains(materia)
	
	method darDeBaja(materia){
		if (materias.contains(materia)){
			materias.remove(materia)
		}
	}
	
	method asistirAMateria(materia){
		if (materias.contains(materia)){
			materia.asisteEstudiantes(self)
		}
	}
	
	method aprenderHechiso(hechiso){
		hechisos.add(hechiso)
	}
	
	method tiene(hechiso) = hechisos.contains(hechiso)
	
	method puedeLanzar(hechiso) = hechiso.puedeSerLanzadoPor(self) and self.tiene(hechiso)
	
	method lanzarHecisoA(individuo, hechiso){
		if (self.puedeLanzar(hechiso)){
			individuo.perderSalud(hechiso.potenciaAtaque())
			hechiso.consecuencia(self)
			return "Golpe Directo"
		}
		else{
			return new Exception(message = "El estudiante no puede lanzar este hechiso, porque no cumple las condiciones.")
		}
	}
	
	method diminuirHabilidad(cant){
		habilidad = 0.max(habilidad - cant)
	}
	
	method cambiarCasa(){
		casa = casa.siguiente()
	}
	
}

class Materia{
	const profesor
	var property hechiso
	const criatura
	const estudiantesPresentes = []
	
	method asisteEstudiantes(estudiante){
		estudiantesPresentes.add(estudiante)
	}
	
	method sacarEstudiante(estudiante){
		estudiantesPresentes.remove(estudiante)
	}
	
	method cambiarEchiso(nuevo){
		hechiso = nuevo
	}
	
	method dictarMateria(){
		estudiantesPresentes.forEach{es => es.aprenderHechiso(hechiso)}
	}
	
	method realizarPractica(){
		estudiantesPresentes.forEach{es => es.lanzarHecisoA(criatura, hechiso)}
	}
	
	method claseFinalizada() {
		estudiantesPresentes.clear()
	} 
}

class HechisoComun{
	const nivelDificultad
	
	method puedeSerLanzadoPor(estudiante) = estudiante.habilidad() > nivelDificultad
	
	method consecuencia(estudiante){}
	
	method potenciaAtaque() = nivelDificultad + 10
}

class HechisoImperdonable inherits HechisoComun{
	const danoColateral
	
	
	override method consecuencia(estudiante){
		estudiante.perderSalud(danoColateral)	
	}
	
	override method potenciaAtaque() = super() * 2
}

class HechisosDeBuenos inherits HechisoComun{
	override method puedeSerLanzadoPor(estudiante) = !estudiante.esPeligroso()
	
	override method consecuencia(estudiante){
		estudiante.diminuirHabilidad(1)
	}
}

class HechisosPuros inherits HechisoComun{
	override method puedeSerLanzadoPor(estudiante) = estudiante.sangrePura()
	
	override method consecuencia(estudiante){
		estudiante.cambiarCasa()
	}
	
	override method potenciaAtaque() = super() + 5
	
}

class HechisosImpuros inherits HechisoComun{
	override method puedeSerLanzadoPor(estudiante) = !estudiante.sangrePura()
	
	override method consecuencia(estudiante){
		estudiante.cambiarCasa()
	}
	
	override method potenciaAtaque() = super() + 1
	
}

