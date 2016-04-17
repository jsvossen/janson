module PostsHelper

	def descriptive_link(post)
		if post.body
			snip = post.body.size > 50 ? post.body[0..50]+"..." : post.body 
			snip = strip_tags(snip)
			if post.photo
				("photo: " + link_to(snip, post_path(post))).html_safe
			else
				("post: " + link_to(snip, post_path(post))).html_safe
			end
		else
			link_to("photo", post_path(post))
		end
	end

end
