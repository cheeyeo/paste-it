class SnippetsController < ApplicationController
  
  layout 'main'
  
  def index
    @snippets = Snippet.test(params[:page])
    @h=Snippet.languages
  end
  
  def new
    @snippet = Snippet.new
    @extensions=Snippet.load_extensions
  end
  
  def create
    @snippet=Snippet.new(params[:snippet])
    if @snippet.save
      #use arry to store ids of snippets in the cookie
      if cookies[:snippets].blank?
        cookies[:snippets] = [@snippet.id.to_s]
      else
        cookies[:snippets] = cookies[:snippets] << ",#{@snippet.id}"
      end
      
      
      redirect_to(@snippet)
    else
      render :action=>'new'
    end
  end
  
  
  def document_write(&block)
      output=capture(&block).rstrip
      buf=""
      output.each do |x|
        next if x.blank?
        buf << 'document.write("' + escape_javascript(x) + '");' + "\n"
      end
      concat(buf,block.binding)
  end
  
  
  #cache here??
  def show
    @snippet= case
      when params[:id]
        Snippet.fetch(params[:id])
      when params[:permalink]
        Snippet.fetch_permalink(params[:permalink])
      end
    
    @content= @snippet.get_formatted_content
    respond_to do |format|
      #format.js {render :layout => false, :text=>@snippet.to_json } for rendering json??
      #format.js { render :text => @snippet.embed_js.delete!("\n"), :layout => false } #show.js.erb
      
      format.js do
        #render :text => @snippet.embed_js
        render :layout => false
      end
      
      format.html   
      format.text { render :text => @snippet.body, :layout => false}
    end
  end
  
  
  
  def edit
    #@snippet = Snippet.test2(params[:id])
    if cookies[:snippets].nil? 
      redirect_to(snippets_path)
    elsif !(cookies[:snippets].split(",").include?("#{params[:id]}")) #cookies not nil so need to check
       redirect_to(snippets_path)
    end
    
    @snippet = Snippet.fetch(params[:id])
  end
  
  def destroy
    @snippet = Snippet.fetch(params[:id])
    @snippet.destroy
    #delete cookie if it exist
    t=cookies[:snippets].split(",")
    t.delete_if {|x| x === "#{params[:id]}"}
    cookies[:snippets] = t
    redirect_to(snippets_path)
  end
  
  def update
    #@snippet = Snippet.find(params[:id])
    @snippet = Snippet.fetch(params[:id])
    if @snippet.update_attributes(params[:snippet])
      redirect_to(@snippet)
    else
      render :action=>"edit"
    end
  end
  
  def update_cat
    @snippet = Snippet.fetch(params[:id])
    @snippet.desc=params[:desc]
    #use update_attribute here not save as it re-generates new permalink
    #and cookie cannot be found
    @snippet.save!
    redirect_to (@snippet)
  end
  
  def download
    @snippet = Snippet.fetch(params[:id])
    @content=@snippet.body
    name=(@snippet.file_name.blank?) ? @snippet.permalink + @snippet.file_ext : @snippet.file_name
    #send file to user for download??
    send_data @content, :disposition => 'attachment', :filename=>name
  end
  
  def search
    #@results = Snippet.cached_search(params[:q])
    #@results = Snippet.search("#{params[:q]}", [:file_ext],:order=>'created_at desc',:conditions=>'private != 1')
    @results = Snippet.search(params[:q],params[:page])
    #@res =  @results.paginate
    
  end
 
  
end
