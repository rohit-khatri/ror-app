class PostsController < ApplicationController
	before_action :redirect_if_not_signed_in, only: [:new]

	def index
	    @hobby_posts = Post.by_branch('hobby').limit(8)
	    @study_posts = Post.by_branch('study').limit(8)
	    @team_posts = Post.by_branch('team').limit(8)
	end

	def show
		@post = Post.find(params[:id])

		if user_signed_in?
		  @message_has_been_sent = conversation_exist?
		end
	end

	def hobby
	    posts_for_branch(params[:action])
	end

	def study
	    posts_for_branch(params[:action])
	end

	def team
	    posts_for_branch(params[:action])
	end

	# def get_posts(branch)
	#   branch = params[:action]
	#   search = params[:search]
	#   category = params[:category]

	#   if category.blank? && search.blank?
	#     posts = Post.by_branch(branch).all
	#   elsif category.blank? && search.present?
	#     posts = Post.by_branch(branch).search(search)
	#   elsif category.present? && search.blank?
	#     posts = Post.by_category(branch, category)
	#   elsif category.present? && search.present?
	#     posts = Post.by_category(branch, category).search(search)
	#   else
	#   end
	# end

	def new
    	@branch = params[:branch]
    	@categories = Category.where(branch: @branch)
    	@post = Post.new
    end

    def create
    	@post = Post.new(post_params)
    	if @post.save
    		redirect_to post_path(@post)
    	else
    		redirect_to root_path
    	end
    end

    private

    def get_posts()
	    PostsForBranchService.new({
	      search: params[:search],
	      category: params[:category],
	      branch: params[:action]
	    }).call
    end

	def posts_for_branch(branch)
		@categories = Category.where(branch: branch)
		@posts = get_posts()
	end

	def post_params
	  params.require(:post).permit(:content, :title, :category_id)
	                       .merge(user_id: current_user.id)
	end

	def conversation_exist?
		Private::Conversation.between_users(current_user.id, @post.user.id).present?
	end

end