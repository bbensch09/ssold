class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :create_lesson_from_cookie

  private

  def create_lesson_from_cookie
    return unless current_user && session[:lesson_time]
    params[:lesson_time] = session.delete(:lesson_time)
    lesson = create_lesson
    flash[:notice] = "Your <a href='#{lesson_path(lesson)}'>lesson</a> request is being processed.".html_safe
  end

  def create_lesson
    lesson = Lesson.new
    lesson.lesson_time = LessonTime.find_or_create_by(lesson_time_params)
    lesson.student = current_user
    lesson.save
    return lesson
  end

  def lesson_time_params
    params.require(:lesson_time).permit(:date, :slot)
  end
end
