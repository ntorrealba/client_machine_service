class Appointment
  attr_accessor :id, :user_id, :vehicle_id, :description, :appointment_date, :errors

  def self.index(user_id, search = {})
    response = RestClient.get("localhost:3000/users/#{user_id}/appointments", { accept: 'application/json', params: search})
    appointments = JSON.parse(response.body)

    appointments['appointment'].map do |appointment|
      Appointment.new(appointment)
    end
  end

  def self.show(id)
    response = RestClient.get("localhost:3000/appointments/#{id}", { accept: 'application/json' })
    attributes = JSON.parse(response.body)
    Appointment.new(attributes['appointment'])
  end

  def self.create(user_id, params)
    payload = params
    response = RestClient.post("localhost:3000/users/#{user_id}/appointments", payload.to_json, {content_type: :json, accept: :json})
    attributes = JSON.parse(response.body)
    Appointment.new(attributes['appointment'])
  end

  def self.update(id, params)
    payload = params
    response = RestClient.put("localhost:3000/appointments/#{id}", payload.to_json, {content_type: :json, accept: :json})
    attributes = JSON.parse(response.body)
    Appointment.new(attributes['appointment'])
  end

  def self.delete(id)
    response = RestClient.delete("localhost:3000/appointments/#{id}", { accept: 'application/json' })
    attributes = JSON.parse(response.body)
    Appointment.new(attributes['appointment'])
  end

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @vehicle_id = options['vehicle_id']
    @description = options['description']
    @appointment_date = options['appointment_date']
    @errors = options['errors'] || []
  end


  def save
    params = {
    vehicle_id: @vehicle_id,
    description: @description,
    appointment_date: appointment_date
    }
    appointment = Appointment.create(user_id, params)

    commit_appointment(appointment)

    if self.id
      true
    else
      false
    end
  end

  def show
    appointment = Appointment.show(self.id)
    commit_appointment(appointment)

    puts "ID Usuario:  #{user_id}"
    puts "ID Vehiculo: #{vehicle_id}"
    puts "Fecha:       #{appointment_date}"
    puts "Descripcion: #{description}"
  end

  def update
    params = {
      vehicle_id: @vehicle_id,
      description: @description,
      appointment_date: appointment_date
    }

    appointment = Appointment.update(self.id, params)
    commit_appointment(appointment)

    if appointment.errors.any?
      false
    else
      true
    end
  end

  def delete
    appointment = Appointment.delete(self.id)
    commit_appointment(appointment)

    if appointment.errors.any?
      false
    else
      true
    end
  end

  private

  def commit_appointment(resource)

    appointment            = resource
    self.id                = appointment.id
    self.user_id           = appointment.user_id
    self.vehicle_id        = appointment.vehicle_id
    self.description       = appointment.description
    self.appointment_date  = appointment.appointment_date
    self.errors            = appointment.errors
  end

end
