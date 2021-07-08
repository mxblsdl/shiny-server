
// need to determine the correct width to return the elements to
const width = $('.cont').width();
const height = $('.cont').height();

// $('.yellow-dot').click(function() {
//     $(this).siblings().animate({
//         width: 30,
//         height: 30
//     }, 400);
// });

$('.yellow-dot').click(function() {
    $(this).siblings('p').slideUp('medium');
});


$('.green-dot').click(function() {
    $(this).siblings('p').slideDown('medium');
});

// $('.green-dot').click(function() {
//         $(this).siblings().animate({
//             width: width,
//             height: height
//         });
//     });

$('.red-dot').click(function() {
    $(this).parent().hide(300);
});

$('#reset').click(function() {
    $('.box').show(300);
    $('.box').children('p').slideDown('medium');
});

