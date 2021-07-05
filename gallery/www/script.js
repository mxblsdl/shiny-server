$('.yellow-dot').click(function() {
    $(this).siblings('p').slideUp('medium');
});

$('.green-dot').click(function() {
    $(this).siblings('p').slideDown('medium');
});

$('.red-dot').click(function() {
    $(this).parent().hide(300);
});

$('#reset').click(function() {
    $('.box').show(300);
    $('.box').children('p').slideDown('medium');
});