$(document).ready(function(){
    // add ids to headings to accommodate anchor links
    $('h1').each(function(index) {
      $(this).attr('id', $(this).text().replace(/[\s]+/g, "-").replace(/[\.]+/g,"").toLowerCase());
    });
    $('h2').each(function(index) {
      $(this).attr('id', $(this).text().replace(/[\s]+/g, "-").replace(/[\.]+/g,"").toLowerCase());
    });
    $('h3').each(function(index) {
      $(this).attr('id', $(this).text().replace(/[\s]+/g, "-").replace(/[\.]+/g,"").toLowerCase());
    });
});
