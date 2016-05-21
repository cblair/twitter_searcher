// ### tweets.js
// This file depends on application.js being loaded first. In the future,
// we should use es6 imports. But not necessary for this tiny project.
// #### Dependencies
// * `dataTable` - A dataTable object returned from $('...').DataTable().

$(document).ready(function () {

    // Options
    // Hide the search and display count boxes. We only let them search with our
    // few terms, and we limit the results.
    $('#table_id_filter').hide();
    $('#table_id_length').hide();

    // ### Search Buttons
    // #### healthcare
    $('a#healthcare').click(function (e) {
       e.preventDefault();
       dataTable.search('healthcare').draw() 
    });
    // #### nasa
    $('a#nasa').click(function (e) {
       e.preventDefault();
       dataTable.search('nasa').draw() 
    });
    // #### open source
    $('a#open-source').click(function (e) {
       e.preventDefault();
       dataTable.search('open source').draw() 
    });

});