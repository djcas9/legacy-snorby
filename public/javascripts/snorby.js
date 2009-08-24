// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
    var currentPage = 2

    // Hide Loading
    $('#loading').hide()

    if (!jQuery.browser.msie) {
        $('#snorby_logo').hover(function() {
            $(this).stop().animate({
                opacity: '0.5'
            })
        },
        function() {
            $(this).stop().animate({
                opacity: '1'
            })
        });
    };

    //Scroll
    $('#scroll_to_comment').click(function() {
        $.scrollTo($('#comment_form'), 800);
    });

    // Remove Event
		$("#update_image_refresh").livequery(function () {
			$(this).tipsy({
	      gravity: "w",
	      offsetBottom: 7
	  });
		return false;
	});
		
		$('#snorby_news, #snorby_bugs, #snorby_wiki, #snorby_footer_info, .add_tipsy').livequery(function () {
			$(this).tipsy({
	      gravity: "s",
	      offsetBottom: 7
	  });
		return false;
	});

		$('#filter_box_link').livequery(function () {
			$(this).tipsy({
	      gravity: "e",
	      offsetBottom: 7
	  });
		return false;
	});

    // DatePicker

    $("#start_datepicker").livequery(function () {
    	$(this).datepicker({
	        duration: '',
	        showTime: true,
	        stepMinutes: 1,
	        stepHours: 1,
	        time24h: false,
	        dateFormat: 'MM d, yy',
					constrainInput: false
	    });
			return false;
    });

    $("#end_datepicker").livequery(function () {
    	$(this).datepicker({
	        duration: '',
	        showTime: true,
	        stepMinutes: 1,
	        stepHours: 1,
	        time24h: false,
	        dateFormat: 'MM d, yy',
					constrainInput: false
	    });
			return false;
    });

		//

    //autocomplete
    $("input#search_keywords").autocomplete("auto_complete_for_search_keywords");
    $("input#search_ip_src").autocomplete("auto_complete_for_search_ip_src");
    $('input#search_ip_dst').autocomplete("auto_complete_for_search_ip_dst");

    // Flash Notice/Error
    $('#flash_notice').animate({
        opacity: '0.9'
    });
    $('#flash_error').animate({
        opacity: '0.9'
    });
    $('#flash_notice').animate({
        opacity: '0.9'
    },
    3000).fadeOut('slow');
    $('#flash_error').animate({
        opacity: '0.9'
    },
    3000).fadeOut('slow');

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
    $('a[rel*=facebox]').livequery(function (event) {
    	$(this).facebox({
	        loading_image: 'loading.gif',
	        close_image: 'closelabel.gif'
	    });
	return false;
    });

    // More
    $('#more').livequery("click", function() {
        var B = $(this);
        B.blur();
        var A = B.attr("href");
        $.ajax({
            url: A + 'page=' + currentPage++,
            type: 'GET',
            dataType: 'script',
            beforeSend: function() {
                $("#more").addClass("loading").html("")
            },
            complete: function() {
                $("#more").removeClass("loading").html("more")
            },
            error: function() {
                alert("Whoops! Something went wrong. Please try refreshing the page.");
            }
        });
			return false;
    });


    // Check ALL
    $("#checkboxall").click(function()
    {
        var checked_status = this.checked;
        $("input[type=checkbox]").each(function()
        {
            this.checked = checked_status;
        });
    });

});