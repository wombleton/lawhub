(function() {
  var difflib = require('./difflib').difflib,
      _ = require('underscore');

  function diff(baseText, newText, options) {
    options = options || {};
    var baseLines,
        context,
        newLines,
        opcodes,
        results,
        segments,
        sm;
    baseLines = difflib.stringAsLines(baseText);
    newLines = difflib.stringAsLines(newText);
    sm = new difflib.SequenceMatcher(baseLines, newLines);
    opcodes = sm.get_opcodes();

    context = options.context;

    results = [];

    segments = _.map(opcodes, function(opcode) {
      return {
        type: opcode[0],
        baseStart: opcode[1],
        baseEnd: opcode[2],
        newStart: opcode[3],
        newEnd: opcode[4]
      };
    });
    _.each(segments, function(segment, index, list) {
      var buffer,
          last,
          postScriptContext,
          previous,
          result = {
            preamble: [],
            postscript: [],
            inserted: [],
            deleted: []
          };

      previous = list[index - 1];
      last = _.last(results);
      baseBuffer = baseLines.slice(segment.baseStart, segment.baseEnd);
      newBuffer = newLines.slice(segment.newStart, segment.newEnd);
      if (index > 0) {
        if (previous.type === 'equal') {
          result.preamble = baseLines.slice(previous.baseStart, previous.baseEnd).slice(-context);
        }
      }

      if (index < list.length - 1) {
        if (last) {
          if (segment.type === 'equal' && previous && _.isNumber(context)) {
            if (baseBuffer.length >= context * 2) {
              last.postscript = baseBuffer.slice(0, context);
            } else if (baseBuffer.length > context) {
              last.postscript = baseBuffer.slice(0, baseBuffer.length - context);
            }
          }
        }
      } else {
        if (segment.type === 'equal' && last) {
          last.postscript = baseBuffer.slice(0, context);
        }
      }

      if (segment.type === 'insert') {
        result.inserted = newBuffer;
      } else if (segment.type === 'delete') {
        result.deleted = baseBuffer;
      } else if (segment.type === 'replace') {
        result.inserted = newBuffer;
        result.deleted = baseBuffer;
      }
      if (segment.type !== 'equal') {
        results.push(result);
      }
    });
    return results;
  }
  module.exports.diff = diff;
}).call(this);
