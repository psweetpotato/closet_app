class UsersController < ApplicationController
  before_action :authenticate,            except: [:new, :create]
  before_action :load_user,               except: [:index, :new, :create]
  before_action :authorize_admin_only,    only:   :index
  before_action :authorize_user_only,     only:   :show
  before_action :authorize_user_or_admin, except: [:index, :show, :new, :create]

  def dashboard
  end

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new({role: 'client'}.merge(user_params))

    if @user.save
      log_in(@user)
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render(:edit)
    end
  end

  def update_password
    if !@user.authenticate(user_password_params[:old_password])
      @user.errors.add(:old_password, 'must match the current password')
      render(:password)
    elsif user_password_params[:password].blank?
      @user.errors.add(:new_password, 'can\'t be blank!')
      render(:password)
    elsif @user.update(user_password_params.except(:old_password))
      flash[:notice] = "Your password has been updated!"
      redirect_to user_path(@user)
    else
      render(:password)
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :city,
        :state)
    end

      def user_password_params
    @user_password_params ||= params.require(:user).permit(
      :old_password,
      :password,
      :password_confirmation
    )
  end

  def load_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path if !@user
  end

  def authorize_admin_only
    unless current_user.is_admin?
      redirect_to user_path(current_user)
    end
  end

  def authorize_user_only
    unless current_user == @user
      redirect_to user_path(current_user)
    end
  end

  def authorize_user_or_admin
    unless current_user == @user || current_user.is_admin?
      redirect_to user_path(current_user)
    end
  end
end
