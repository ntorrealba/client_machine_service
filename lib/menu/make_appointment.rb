require_relative "../appointments"
require_relative "../users"
require_relative "../vehicles"


class MakeAppointment

  def start
    appointment = Appointment.new
    found = true

    while found do
      puts "Ingrese los siguientes datos para su agendar su cita:"
      puts ""

      search_user(appointment)
      register_appointment(appointment)
      search_vehicle(appointment)

      if appointment.save
        puts ""
        puts "¡Su cita esta agendada!"
        puts ""
        puts "¿Desea volver al menu?
            SI: 1 / NO: 2"
        found = false
      else
        appointment.errors.each{|message| puts message}

      end
    end
  end

  def register_appointment(appointment)
    puts "Indique el motivo de la cita"
    appointment.description = gets.chomp
    puts "Indique la fecha para la cita (dd/mm/aa)"
    appointment.appointment_date = gets.chomp
  end

  def search_user(appointment)
    valid = true

    while valid do
      puts "Usuario (email):"
      email = gets.chomp
      search = {search: {email: email}}
      user = User.index(search)

      if user != nil
        appointment.user_id = user[0].id
        valid = false
      else
        puts appointment.errors(:user_id, 'este usuario no existe, intente de nuevo')
      end

    end
  end

  def search_vehicle(appointment)
    valid = true

    while valid do
      puts "Indique la placa de su Vehiculo"
      vin = gets.chomp
      search = {search: {vin: vin}}
      vehicle = Vehicle.index(appointment.user_id, search)

      if vehicle != nil
       appointment.vehicle_id = vehicle[0].id
       valid = false
      else
        puts appointment.errors(:vehicle_id, 'esta placa no se encuentra registrada, intente de nuevo')
      end
    end
  end
end