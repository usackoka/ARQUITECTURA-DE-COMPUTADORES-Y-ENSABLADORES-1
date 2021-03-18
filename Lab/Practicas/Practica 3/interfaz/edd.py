class nodo():
	def __init__(self, cantidad, hora):
		self.cantidad = cantidad
		self.hora = hora
		self.siguiente = None

class Cola():
	def __init__(self):
		self.primero = None

	def delete(self,nodo):
		if nodo == self.primero:
			self.primero = self.primero.siguiente
			print "eliminando"
		else:
			temp = self.primero
			while(temp.siguiente != None): #Mientras tenga un siguiente
				if(temp.siguiente == nodo):
					temp.siguiente = temp.siguiente.siguiente
					print "eliminando"
					return
				temp = temp.siguiente
			print "El nodo que quiere eliminar no existe"

			

	def deleteFirst(self):
		print "eliminando primero"
		self.primero = self.primero.siguiente

	def insertar(self, cantidad, hora):
		Nodo = nodo(cantidad,hora)
		if self.primero == None :
			self.primero = Nodo
		else :
			temp = self.primero
			while temp.siguiente != None:
				temp = temp.siguiente
			temp.siguiente = Nodo
	def imprimir(self):
		if self.primero == None:
			print("La cola esta vacia")
		else:
			temp = self.primero
			while temp.siguiente != None:
				print(temp.cantidad,"-",temp.fecha)
				temp = temp.siguiente
	def getPrimero(self):
		return self.primero
