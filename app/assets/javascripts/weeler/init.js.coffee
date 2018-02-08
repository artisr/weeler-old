#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require turbolinks
#= require ./vendor/moment
#= require_tree ./vendor
#= require_tree ./lib
#= require weeler/app
#= require_self

app = {
  boot: () ->
    $('.weeler-file-inputs').bootstrapFileInput()
    sortable.init()
    flash.init();
    $('[data-provide="rowlink"],[data-provides="rowlink"]').each () ->
      $(this).rowlink($(this).data())
    $('.datepicker').datetimepicker({
      format: 'DD/MM/YYYY'
    });
    $('.datetimepicker').datetimepicker();
}

$(document).on 'turbolinks:load', ->
  app.boot()
