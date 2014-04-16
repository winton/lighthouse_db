#= require jquery
#= require bootstrap
#= require_tree ./lib

$ ->
  $('.input-daterange').datepicker(todayBtn: "linked")
  $('a.team').click ->
    $("input", $(this).parent().parent()).each (i, item) ->
      $(item).prop("checked", !$(item).prop("checked"))
    false
  $('#select-all').click ->
    $("#teams input").each (i, item) ->
      $(item).prop("checked", true)
    false
  $('#deselect-all').click ->
    $("#teams input").each (i, item) ->
      $(item).prop("checked", false)
    false