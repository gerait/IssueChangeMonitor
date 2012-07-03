// Event.observe(window, 'load',
//   function() {
// 
//     if(typeof(jsToolBar) != "undefined") {
// 
//       // SQL toolbar
//       jsToolBar.prototype.elements.sql = {
//         type: 'button',
//         title: 'SQL',
//         fn: {
//           wiki: function() { this.encloseLineSelection('<pre><code class="sql">\n', '\n</code></pr e>') }
//         }
//       }
// 
//       // redraw toolbar to get the new button to show
//       wikiToolbar.draw();
//     }
//   }
// );

Event.observe(window, 'load',
  function() {
    $$('tr.issue td.subject').each(function(el) {
      var issue_id = $(el).up('tr.issue').id.replace(/[^0-9]/g, '')
      if(issue_id != null && issue_id.length > 0){
        new Ajax.Request("/issue_changes/check.json", 
          { asynchronous:true, 
            method: 'get',
            parameters: {issue_id: issue_id},
            evalJSON: true,
            onSuccess:  function(response) {
              var label = response.responseJSON['label'];
              var css_class = response.responseJSON['css_class'];
              if((label != null || label != undefined) && label.length > 0){
                var link = $(el).down('a')
                $(link).update(["<span class='", css_class, "'>", label, "</span>", $(link).innerHTML].join(''))
              }
            }
          }
        );
      }
    });
  }
);
