from Tkinter import *
import serial
import thread
import time
import matplotlib.pyplot as plt
import numpy as np
from edd import Cola

colaAutomaticas = Cola()
colaManuales = Cola()
x = []
y = []

arduino = serial.Serial('COM3',baudrate=9600,timeout=3.0)
cadena=''
cantidad = 0 
root = Tk()
Vmanual = Toplevel()
VAutomatico = Toplevel()
txtCantidadM = Entry(Vmanual)
txtCantidadA = Entry(VAutomatico)
txthoraA = Entry(VAutomatico)

def DespacharManual():
	valor = txtCantidadM.get()
	colaManuales.insertar(valor,0)

def DespacharAutomatico():
	valor = txtCantidadA.get()
	horaDespacho = txthoraA.get()
	colaAutomaticas.insertar(valor,horaDespacho)

def ocultarAutomatico():
	ocultar(VAutomatico)

def ocultarManual():
	ocultar(Vmanual)

lblcantidad = Label(Vmanual, text="Cantidad de Producto")
btnEnviarM = Button(Vmanual, text="Despachar", command=DespacharManual)
btnsalir = Button(Vmanual,text="Salir",command=ocultarManual)
lblcantidadA = Label(VAutomatico,text="Cantidad de Producto")
lblHoraA = Label(VAutomatico, text="Hora a Despachar (H:M)")
btnEnviarA = Button(VAutomatico,text="Despachar",command=DespacharAutomatico)
btnsalira = Button(VAutomatico, text="Salir",command=ocultarAutomatico)

def main():
	ocultar(Vmanual)
	ocultar(VAutomatico)
	root.title("Dispensador")
	root.minsize(width=400, height=430)
	root.maxsize(width=400, height=430)
	imgM = PhotoImage(file="C:\Users\Davidd\Desktop\interfaz\manual.gif")
	imgA = PhotoImage(file="C:\Users\Davidd\Desktop\interfaz\utomatico.gif")
	imgG = PhotoImage(file="C:\Users\Davidd\Desktop\interfaz\grafica.gif")
	botonM = Button(root, image = imgM, command=DespachoManual)
	botonM.pack()
	botonA = Button(root, image= imgA, command=DespachoAutomatico)
	botonA.pack()
	botonG = Button(root, image = imgG, command=Grafica)
	botonG.pack()
	botonH = Button(root, command=ActualizarHora)
	botonH.pack()
	
	root.mainloop()

def ocultar(ventana):
	ventana.withdraw()
def mostrar(ventana):
	ventana.deiconify()
def ejecutar(f):
	root.after(200,f)

def DespachoManual():
	#ocultar(VAutomatico)
	ejecutar(mostrar(Vmanual))
	Vmanual.title("Solicitud Manual")
	Vmanual.minsize(width=400, height=400)
	Vmanual.maxsize(width=400, height=400)
	
	lblcantidad.pack()
	txtCantidadM.pack()
	
	btnEnviarM.pack()
	
	btnsalir.pack()
	Vmanual.mainloop()



def DespachoAutomatico():
	#ocultar(Vmanual)
	ejecutar(mostrar(VAutomatico))
	VAutomatico.title("Solicitud Automatica")
	VAutomatico.minsize(width=400, height=400)
	VAutomatico.maxsize(width=400, height=400)
	
	lblcantidadA.pack()
	txtCantidadA.pack()
	
	lblHoraA.pack()
	txthoraA.pack()
	
	btnEnviarA.pack()
	
	btnsalira.pack()
	VAutomatico.mainloop()



def Grafica():
	plt.plot(x,y)
	plt.xlabel('x (Tiempo)')
	plt.ylabel('y (Cantidad)')
	plt.title('Servicios de Dispensador')
	plt.show()
	plt.savefig('grafica.png')



def ActualizarHora():
	arduino.write('h')
	hora = time.strftime("%H:%M")
	arduino.write(hora)

def Punto(xx,yy):
	x.append(xx)
	y.append(yy)

def funcion(inicio, fin):
	print "Hilo solicitudes automaticas"
	while True:
		hora = time.strftime("%H:%M") #actualizo hora
		hora2 = time.strftime("%M")
		temp = colaAutomaticas.primero
		if temp != None:
			while temp.siguiente != None:
				if temp.hora == hora:
					arduino.write('a')
					time.sleep(0.1)
					arduino.write(temp.cantidad)
					Punto(int(hora2),int(temp.cantidad))
					colaAutomaticas.delete(temp)
				temp = temp.siguiente
			if temp.hora == hora:
				arduino.write('a')
				time.sleep(0.1)
				arduino.write(temp.cantidad)
				colaAutomaticas.delete(temp)

def funcion2(inicio,fin):
	print "Hilo Solicitudes manuales"
	while True:
		hora2 = time.strftime("%M")
		if colaManuales.primero != None:
			valor = colaManuales.primero.cantidad
			arduino.write('m')
			time.sleep(0.1)
			arduino.write(valor)
			Punto(int(hora2),int(colaManuales.primero.cantidad))
			colaManuales.deleteFirst()

if __name__ == "__main__":
	thread.start_new_thread(funcion,(3,1))
	thread.start_new_thread(funcion2,(3,1))
	main()