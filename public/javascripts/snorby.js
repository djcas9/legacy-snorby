// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
	var currentPage = 2
	// Hide Loading 
	$('#loading').hide()
	
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
		});};
		
	//Scroll
	$('#scroll_to_comment').click(function() {
		$.scrollTo($('#comment_form'), 800);
	});
	
	// Remove Event

	$('#update_image_refresh').qtip({
	   	content: {
				text: 'Update	 Cache!',
				button: 'close'
			},
	   	show: 'mouseover',
	   	hide: 'mouseout',
			style: { name: 'dark', tip: true, border: { width: 3, radius: 3 } },
			show: {
				effect: { type: 'fade', length: 300 }
			},
			hide: {
				effect: { type: 'fade', length: 300 }
			},
			position: {
			      corner: {
			         target: 'topMiddle',
			         tooltip: 'bottomMiddle'
			      }
			   }
	});


	// DatePicker
	$("#start_datepicker,#end_datepicker").datepicker({  
    duration: '',  
    showTime: true,  
    constrainInput: true,  
    stepMinutes: 1,
	  stepHours: 1,  
	  altTimeField: '',  
	  time24h: false,
	  dateFormat: 'MM d, yy',
		showButtonPanel: false
	 });

  //autocomplete
	$("input#search_keywords").autocomplete("auto_complete_for_search_keywords");
	$("input#search_ip_src").autocomplete("auto_complete_for_search_ip_src");
	$('input#search_ip_dst').autocomplete("auto_complete_for_search_ip_dst");

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
	
	// More
	$('#more').live("click", function() {
		var B = $(this);
	    B.blur();
	    var A = B.attr("href");
		$.ajax({
		  url: A + '?page=' + currentPage++,
		  type: 'GET',
		  dataType: 'script',
			beforeSend: function() {$("#more").addClass("loading").html("")},
			complete: function() {$("#more").removeClass("loading").html("more")},
	  	//success: function() {$("#events");},
	  	error: function() {alert("Whoops! Something went wrong. Please try refreshing the page.");}
		});
		return false;
	});
	
});