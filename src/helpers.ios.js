/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */

'use strict';

var React = require('react-native');
var {
  AlertIOS,
} = React;

var awSnap = function(message, recoverySuggestion, onPress) {
  AlertIOS.alert(
    message,
    recoverySuggestion,
    [{text: 'Oh snap!', onPress: onPress}]
  );
};

module.exports.awSnap = awSnap;
