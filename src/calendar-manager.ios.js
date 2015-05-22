/*global require, fetch*/
/*jshint -W097, esnext:true */

'use strict';

var React = require('react-native');
var {
  DeviceEventEmitter,
} = React;

var NativeCalendarManager = require('NativeModules').CalendarManager;

var DEVICE_EVENTSTORE_EVENT = 'eventStoreChanged',
    eventStoreChangedHandlers = {};

var CalendarManager = {

  addEventListener: function(type, handler) {
    eventStoreChangedHandlers[handler] = DeviceEventEmitter.addListener(
      DEVICE_EVENTSTORE_EVENT,
      ()=> {
        handler();
      }
    );

    return {
      remove: function() {
        CalendarManager.removeEventListener(type, handler);
      }
    };
  },

  removeEventListener: function(type, handler) {
    if (!eventStoreChangedHandlers[handler]) {
      return;
    }

    eventStoreChangedHandlers[handler].remove();
    eventStoreChangedHandlers[handler] = null;
  },

  requestAccessToCalendarEvents:
    NativeCalendarManager.requestAccessToCalendarEvents,

  calendarNames: NativeCalendarManager.calendarNames,

  calendarNameForIdentifier:
    NativeCalendarManager.calendarNameForIdentifier,

  currentEventsInCalendar: NativeCalendarManager.currentEventsInCalendar,

  todaysUpcomingEventsInCalendar:
    NativeCalendarManager.todaysUpcomingEventsInCalendar,

};

module.exports = CalendarManager;
