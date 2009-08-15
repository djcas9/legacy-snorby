// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
	
	if (!jQuery.browser.msie) { 
		$('#snorby_logo').hover(function() {
			$(this).stop().animate({opacity: '0.5'})
		}, function() {
			$(this).stop().animate({opacity: '1'})
		});
		
		// Menu
		$('#menubar a').hover(function() {
			$(this).stop().fadeTo(1000, 0.6)
		}, function() {
			$(this).stop().fadeTo(1000, 1)
		});
		
		};

	// Flash Notice/Error
	$('#flash_notice').animate({opacity: '0.9'});$('#flash_error').animate({opacity: '0.9'});
	$('#flash_notice').animate({opacity: '0.9'}, 3000).fadeOut('slow');
	$('#flash_error').animate({opacity: '0.9'}, 3000).fadeOut('slow');
	
	$('#flash_notice').click(function() {
		$(this).remove()
	});
	$('#flash_error').click(function() {
		$(this).remove()
	});


	// Links
	$('#remove_fade_in').click(function() {
		// $('#event_show_page').animate({opacity: '0.2'})
	});
	
	// FaceBox
	$('a[rel*=facebox]').facebox({ loading_image : 'loading.gif', close_image : 'closelabel.gif' }); 
});