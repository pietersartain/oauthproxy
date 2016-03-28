// http://snipplr.com/view/354/parse-query-string-from-script-elements-src-attribute/
/**
 * Helper object to parse the query string variables from 
 * <script> element's src attribute.
 * 
 * For example, in test.html:
 *
 *   <script src="test.js?name=value"></script>
 *
 * and in test.js, you can get query as name/value pairs:
 * 
 *   var queries = new ScriptQuery('test.js').parse();
 *   for (var name in queries) {
 *     var values = queries[name]; // property is Array instance.
 *     ...
 *   }
 * 
 * If you would like to avoid array manipulation.
 * ScriptQuery also provides flatten method, which returns 
 * only first value for each properties.
 * 
 *   var queries = new ScriptQuery('test.js').flatten();
 *   for (var name in queries) {
 *     alert(queries[name]); // property is simply string
 *   }
 */
var ScriptQuery = function(scriptPath) {
  this.scriptPath = scriptPath;
}
ScriptQuery.prototype = {
  get: function() {
    var srcRegex = new RegExp(this.scriptPath.replace('.', '\\.') + '(\\?.*)?$');
    var scripts = document.getElementsByTagName("script");
    for (var i = 0; i < scripts.length; i++) {
      var script = scripts[i];
      if (script.src && script.src.match(srcRegex)) {
        var query = script.src.match(/\?([^#]*)(#.*)?/);
        return !query ? '' : query[1];
      }
    }
    return '';
  },
  parse: function() {
    var result = {};
    var query = this.get();
    var components = query.split('&');
    
    for (var i = 0; i < components.length; i++) {
      var pair = components[i].split('=');
      var name = pair[0], value = pair[1];
      
      if (!result[name]) result[name] = [];
      // decode
      if (!value) {
        value = 'true';
      } else {
        try {
          value = decodeURIComponent(value);
        } catch (e) {
          value = unescape(value);
        }
      }
      
      // MacIE way
      var values = result[name];
      values[values.length] = value;
    }
    return result;
  },
  flatten: function() {
    var queries = this.parse();
    for (var name in queries) {
      queries[name] = queries[name][0];
    }
    return queries;
  },
  toString: function() {
    return 'ScriptQuery [path=' + this.scriptPath + ']';
  }
}