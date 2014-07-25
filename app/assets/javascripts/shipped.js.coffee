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

  state_cells  = $(".state")
  state_inputs = $("#states input")

  state_inputs.change ->
    checked = $.makeArray state_inputs.filter(":checked").map (i, item) ->
      $(item).val()
    state_cells.each (i, item) ->
      if checked.indexOf($.trim($(item).text())) > -1 || !checked.length
        $(item).closest("tr").show()
      else
        $(item).closest("tr").hide()
