$(document).ready(
  function() {
    // Check all by one requets
    if($('tr.issue td.subject') != undefined){
        var project_id = $("#issue_change_project_id").val();
        var issue_ids = $('tr.issue').map(function() {
          return "issue_ids[]=" + (typeof this.id != 'undefined' ? this.id.replace(/[^0-9]/g, '') : '');
        }).get().join(';')
        if(issue_ids.length > 0){
          $.ajax({url: "/issue_changes/check_all.js?project_id=" + project_id + "&" + issue_ids, type: 'post'});
        }
      }
  }
);
