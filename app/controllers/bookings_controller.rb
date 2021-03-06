class BookingsController < ApplicationController
  def index
    @bookings = Booking.joins(:instrument).with_instruments_for(current_user)
  end

  def accept
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: true)
    redirect_to bookings_path
  end

  def reject
    @booking = Booking.find(params[:booking_id])
    @booking.update(status: false)
    redirect_to bookings_path
  end

  def new
    @booking = Booking.new
    @instrument = Instrument.find(params[:instrument_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @instrument = Instrument.find(params[:instrument_id])
    @booking.instrument = @instrument
    @booking.user = current_user

    if @booking.save
      redirect_to booking_confirmation_path(@booking)
    else
      render :new
    end
  end

  def confirmation
    @booking = Booking.find(params[:booking_id])
  end

  private
  def booking_params
    params.require(:booking).permit(:content, :start_time, :end_time)
  end
end
