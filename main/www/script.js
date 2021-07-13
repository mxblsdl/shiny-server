$(document).on('click', 'a[href^="#"]', function (event) {
    event.preventDefault();
    
    $('html, body').animate({
    scrollTop: $($.attr(this, 'href')).offset().top
    }, 200);
  }
);


toTop = function() {window.scrollTo({top: 0, behavior: 'smooth'})};

$("#toTop").click(toTop);

$(window).scroll(function(){
    $('#toTop').toggleClass('scrolled', $(this).scrollTop() > 100);
});
