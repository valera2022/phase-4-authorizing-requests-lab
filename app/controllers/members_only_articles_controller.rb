class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authorize

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private
  
  def authorize 
    return render json:{error: "Not authorized"},status: :unauthorized unless session.include? :user_id
  
  end
  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

# - If a user is not signed in, the `#index` and `#show` actions should return a
#   status code of 401 unauthorized, along with an error message
# - If the user is signed in, the `#index` and `#show` actions should return the
#   JSON data for the members-only articles.