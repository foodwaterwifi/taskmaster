// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// jQuery it up in here
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";

$(function () {

  let timeLogger = $("#time-logger")
  if (timeLogger != null) {

    let getUnixTimestamp = function() {
      return Math.round((new Date()).getTime()/1000)
    }

    let sendRequest = (method, timeBlock, onSuccess, onError, pathAppend) => {
      let text = JSON.stringify({
        time_block: timeBlock,
      })

      console.log(time_block_path)

      $.ajax(time_block_path + (pathAppend != null ? pathAppend : ""), {
        method: method,
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        success: onSuccess,
        error: onError,
      });

      console.log("sent request")
    }

    let calculateTimeSpent = function() {
      let normalRows = timeLogger.find(".time-block-normal-row")
      console.log("There are ", normalRows.length)
      let totalTime = 0
      normalRows.each(function () {
        let row = $(this)
        let startTimeSpan = row.find(".time-block-start-time-span")
        let endTimeSpan = row.find(".time-block-end-time-span")
        let startTime = parseInt(startTimeSpan.text())
        let endTime = parseInt(endTimeSpan.text())
        totalTime += (endTime - startTime)
      })
      console.log(totalTime)

      let seconds = totalTime % 60
      let minutes = Math.floor(totalTime/60)%60
      let hours = Math.floor(totalTime/3600)

      console.log(seconds, minutes, hours)
      return parseInt(hours) + " h " + parseInt(minutes) + " m " + parseInt(seconds) + " s"
    }

    let updateTimeSpent = function() {
      let timeSpentDisplay = $("#time-spent-display")
      timeSpentDisplay.text(calculateTimeSpent())
    }

    let copyRowDisplayToInput = function (row) {
      let startTimeInput = row.find(".time-block-start-time-input")
      let endTimeInput = row.find(".time-block-end-time-input")
      let startTimeSpan = row.find(".time-block-start-time-span")
      let endTimeSpan = row.find(".time-block-end-time-span")
      startTimeInput.val(parseInt(startTimeSpan.text()))
      endTimeInput.val(parseInt(endTimeSpan.text()))
    }

    let copyRowInputToDisplay = function (row) {
      let startTimeInput = row.find(".time-block-start-time-input")
      let endTimeInput = row.find(".time-block-end-time-input")
      let startTimeSpan = row.find(".time-block-start-time-span")
      let endTimeSpan = row.find(".time-block-end-time-span")
      startTimeSpan.text(startTimeInput.val().toString())
      endTimeSpan.text(endTimeInput.val().toString())
    }

    let updateRowDisplay = function (row, startTime, endTime) {
      let startTimeSpan = row.find(".time-block-start-time-span")
      let endTimeSpan = row.find(".time-block-end-time-span")
      startTimeSpan.text(parseInt(startTime))
      endTimeSpan.text(parseInt(endTime))
    }
    // mode can be "edit", "display", or "waiting"
    let updateRowVisibility = function (row, mode) {
      let startTimeInput = row.find(".time-block-start-time-input")
      let endTimeInput = row.find(".time-block-end-time-input")
      let startTimeSpan = row.find(".time-block-start-time-span")
      let endTimeSpan = row.find(".time-block-end-time-span")
      let editButton = row.find(".time-block-edit-button")
      let deleteButton = row.find(".time-block-delete-button")
      let saveButton = row.find(".time-block-save-button")
      let cancelButton = row.find(".time-block-cancel-button")

      startTimeInput.attr("hidden", mode != "edit" || mode == "waiting")
      endTimeInput.attr("hidden", mode != "edit" || mode == "waiting")
      startTimeSpan.attr("hidden", mode != "display" && mode != "waiting")
      endTimeSpan.attr("hidden", mode != "display" && mode != "waiting")
      saveButton.attr("hidden", mode != "edit" || mode == "waiting")
      cancelButton.attr("hidden", mode != "edit" || mode == "waiting")
      editButton.attr("hidden", mode != "display" || mode == "waiting")
      deleteButton.attr("hidden", mode != "display" || mode == "waiting")
    }

    let addNewRow = function (anchor, templateRow, startTime, endTime, timeBlockId) {
      let row = templateRow.clone().insertBefore(anchor)
      row.removeClass("time-block-template-row").addClass("time-block-normal-row")
      row.attr("data-time-block-id", timeBlockId)
      updateRowDisplay(row, startTime, endTime)
      row.attr("hidden", false)
      return row
    }

    let bindNormalRow = function (row) {
      let startTimeInput = row.find(".time-block-start-time-input")
      let endTimeInput = row.find(".time-block-end-time-input")
      let editButton = row.find(".time-block-edit-button")
      let deleteButton = row.find(".time-block-delete-button")
      let saveButton = row.find(".time-block-save-button")
      let cancelButton = row.find(".time-block-cancel-button")

      editButton.click(e => {
        copyRowDisplayToInput(row)
        updateRowVisibility(row, "edit")
      })
      cancelButton.click(e => {
        updateRowVisibility(row, "display")
      })
      saveButton.click(e => {
        let timeBlockId = row.data("time-block-id")
        let startTime = startTimeInput.val()
        let endTime = endTimeInput.val()
        updateRowVisibility(row, "waiting")
        sendRequest("put", {
          id: timeBlockId,
          start_time: startTime,
          end_time: endTime,
        },
        resp => {
          updateRowDisplay(row, resp.data.start_time, resp.data.end_time)
          updateRowVisibility(row, "display")
          updateTimeSpent()
        },
        () => {
          updateRowVisibility(row, "edit")
        },
        "/" + parseInt(timeBlockId))
      })
      deleteButton.click(e => {
        let timeBlockId = row.data("time-block-id")
        console.log(timeBlockId)
        updateRowVisibility(row, "waiting")
        sendRequest("delete", {
          id: timeBlockId,
        },
        () => {
          console.log("row deleted")
          row.remove()
          updateTimeSpent()
        },
        () => {
          console.log("failed to delete row")
          updateRowVisibility(row, "display")
        },
        "/" + parseInt(timeBlockId))
      })
    }

    let bindInputRow = function (row, anchor, templateRow) {
      let startTimeInput = row.find(".time-block-start-time-input")
      let endTimeInput = row.find(".time-block-end-time-input")
      let addButton = row.find(".time-block-add-button")

      addButton.click(e => {
        let startTime = startTimeInput.val()
        let endTime = endTimeInput.val()
        let taskId = addButton.data("task-id")
        console.log("clicked add")
        sendRequest("post", {
          start_time: startTime, end_time: endTime, task_id: taskId,
        },
        resp => {
          console.log("adding new row")
          let row = addNewRow(anchor, templateRow, resp.data.start_time, resp.data.end_time, resp.data.id)
          bindNormalRow(row)
          updateTimeSpent()
        }, null, null)
      })
    }

    let inputRow = timeLogger.find("#time-block-input-row")
    let templateRow = timeLogger.find("#time-block-template-row")
    let normalRows = timeLogger.find(".time-block-normal-row")
    let anchor = timeLogger.find("#time-logger-table-anchor")

    normalRows.each(function () {
      bindNormalRow($(this))
    })

    bindInputRow(inputRow, anchor, templateRow)


    ////////////////////////////////

    let startedTime = 0

    let startLoggingButton = $("#time-logger-log-start")
    let stopLoggingButton = $("#time-logger-log-stop")

    startLoggingButton.click(e => {
      startedTime = getUnixTimestamp()
      startLoggingButton.removeClass("btn-primary").addClass("btn-secondary")
      stopLoggingButton.removeClass("btn-secondary").addClass("btn-primary")
    })
    stopLoggingButton.click(e => {
      let endedTime = getUnixTimestamp()
      let taskId = stopLoggingButton.data("task-id")

      sendRequest("post", {
        start_time: startedTime, end_time: endedTime, task_id: taskId,
      },
      resp => {
        let row = addNewRow(anchor, templateRow, resp.data.start_time, resp.data.end_time, resp.data.id)
        bindNormalRow(row)
        updateTimeSpent()
      }, null, null)

      stopLoggingButton.removeClass("btn-primary").addClass("btn-secondary")
      startLoggingButton.removeClass("btn-secondary").addClass("btn-primary")
    })

    //////////////////////////////

  }

});

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
