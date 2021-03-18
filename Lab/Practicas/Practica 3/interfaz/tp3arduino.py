import serial
import time

arduino = serial.Serial('COM3',baudrate=9600,timeout=3.0)
cadena=''
cantidad = 0 
horaDespacho = ""

def main():
	MENU()

def MENU():

	print "Selecciones una opcion:"
	print "1. Despacho manual"
	print "2. Despacho automatico"
	print "3  Actualizar hora"
	print "4  Salir"
	opcion = int(input("Elija una opcion: "))

	if opcion == 1:
		arduino.write('m')
		time.sleep(0.1)
		while arduino.inWaiting()>0:
			cadena += arduino.readline()
			print cadena.rstrip('\n')
		cantidad = raw_input("cantidad de Pruductos: ")
		arduino.write(cantidad)

		MENU()
	elif opcion == 2:
		arduino.write('a')
		hora = time.strftime("%H:%M")
		print "H"+hora
		time.sleep(1)
		while arduino.inWaiting()>0:
			cadena += arduino.readline()
			print cadena.rstrip('\n')
		#arduino.close()
		cantidad = raw_input("Cantidad de Productos: ")
		arduino.write(cantidad)
		horaDespacho = raw_input("Ingrese hora(H:M): ")

		MENU()
	elif opcion == 3:
		arduino.write('h')
		hora = time.strftime("%H:%M")
		arduino.write(hora)

		MENU()

if __name__ == "__main__":
	main()


	