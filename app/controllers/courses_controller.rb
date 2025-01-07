class CoursesController < ApplicationController
    def index
      courses = Course.all
      render json: courses
    end
  
    def show
      course = Course.find(params[:id])
      render json: course
    end
  
    def create
        user_exists = check_user_exists(params[:user_id])
      
        unless user_exists
          return render json: { error: "User does not exist" }, status: :not_found
        end
      
        course = Course.new(course_params)
        if course.save
          render json: course, status: :created
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
        end
    end
  

    private
            
    def check_user_exists(user_id)
        response = HTTP.get("http://localhost:3001/users/#{user_id}")
        response.status == 200
    end
    
    def course_params
        params.require(:course).permit(:name, :description, :user_id)
    end
      
  end
  