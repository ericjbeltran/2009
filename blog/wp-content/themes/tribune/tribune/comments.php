<?php // Do not delete these lines
	if ('comments.php' == basename($_SERVER['SCRIPT_FILENAME']))
		die ('Please do not load this page directly. Thanks!');

	if (!empty($post->post_password)) { // if there's a password
		if ($_COOKIE['wp-postpass_' . COOKIEHASH] != $post->post_password) {  // and it doesn't match the cookie
			?>

			<p class="nocomments">This post is password protected. Enter the password to view comments.</p>

			<?php
			return;
		}
	}

	/* This variable is for alternating comment background */
	$oddcomment = 'alt';
?>

<!-- You can start editing here. -->

<?php if ($comments) : ?>
	<h3 id="comments-count"><?php comments_number('No Responses', '1 Response', '% Responses' );?></h3>

	<ol class="commentlist">

	<?php foreach ($comments as $comment) : ?>

		<li class="<?php echo $oddcomment; ?> <?php if(function_exists("author_highlight")) author_highlight(); ?>" id="comment-<?php comment_ID() ?>">

			<p class="comment-meta"><span class="comment-author"><strong><?php comment_author_link() ?> Says</strong>:</span>
			<?php if ($comment->comment_approved == '0') : ?>
			<em>Your comment is awaiting moderation.</em>
			<?php endif; ?></p>

			<?php comment_text() ?>

			<p class="comment-meta"><small>Posted on <a href="#comment-<?php comment_ID() ?>" title=""><?php comment_date('F jS, Y') ?> at <?php comment_time() ?></a><?php edit_comment_link('Edit',' | ',''); ?></small></p>

		</li>

	<?php /* Changes every other comment to a different class */
		if ('alt' == $oddcomment) $oddcomment = '';
		else $oddcomment = 'alt';
	?>

	<?php endforeach; /* end for each comment */ ?>

	</ol>

 <?php else : // this is displayed if there are no comments so far ?>

	<?php if ('open' == $post->comment_status) : ?>
		<!-- If comments are open, but there are no comments. -->

	 <?php else : // comments are closed ?>
		<!-- If comments are closed. -->
		<p class="nocomments">Comments are closed.</p>

	<?php endif; ?>
<?php endif; ?>


<?php if ('open' == $post->comment_status) : ?>

<div id="respond">

<h3>Leave a Reply</h3>

<?php if ( get_option('comment_registration') && !$user_ID ) : ?>
<p id="login-req">You must be <a href="<?php echo get_option('siteurl'); ?>/wp-login.php?redirect_to=<?php the_permalink(); ?>">logged in</a> to post a comment.</p>

</div><!-- #respond -->

<?php else : ?>

<form action="<?php echo get_option('siteurl'); ?>/wp-comments-post.php" method="post" id="commentform">

<?php if ( $user_ID ) : ?>

<p><?php _e('Logged in as'); ?> <a href="<?php echo get_option('siteurl'); ?>/wp-admin/profile.php"><?php echo $user_identity; ?></a>. <a href="<?php echo get_option('siteurl'); ?>/wp-login.php?action=logout" title="<?php _e('Log out of this account'); ?>"><?php _e('Logout'); ?> &raquo;</a></p>

<?php else : ?>

<p><small><label for="author"><?php _e('Name'); ?> <?php if ($req) { ?><span class="required"><?php _e('(required)'); ?></span><?php } ?></label></small><br />
<input type="text" name="author" id="author" value="<?php echo $comment_author; ?>" size="25" tabindex="1" /></p>

<p><small><label for="email"><?php _e('Mail (will not be published)'); ?> <?php if ($req) { ?><span class="required"><?php _e('(required)'); ?></span><?php } ?></label></small><br />
<input type="text" name="email" id="email" value="<?php echo $comment_author_email; ?>" size="25" tabindex="2" /></p>

<p><small><label for="url"><?php _e('Website'); ?></label></small><br />
<input type="text" name="url" id="url" value="<?php echo $comment_author_url; ?>" size="25" tabindex="3" /></p>

<?php endif; ?>

<p><textarea name="comment" id="comment" cols="50" rows="15" tabindex="4"></textarea></p>

<p><input name="submit" type="submit" id="submit" tabindex="5" value="<?php _e('Submit Comment'); ?>" />
<input type="hidden" name="comment_post_ID" value="<?php echo $id; ?>" />
</p>
<?php do_action('comment_form', $post->ID); ?>

</form>

</div><!-- #respond -->

<?php endif; // If registration required and not logged in ?>

<?php endif; // if you delete this the sky will fall on your head ?>
