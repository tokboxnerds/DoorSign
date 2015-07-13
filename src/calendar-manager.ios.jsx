/*global require, fetch*/
/*jshint -W097, esnext:true */

'use strict';

import { DeviceEventEmitter } from 'react-native';

import NativeModules from 'NativeModules';

const NativeCalendarManager = NativeModules.CalendarManager;

const DEVICE_EVENTSTORE_EVENT = 'eventStoreChanged';
var eventStoreChangedHandlers = {};

const CalendarManager = {

  addEventListener: function(type, handler) {
    eventStoreChangedHandlers[handler] = DeviceEventEmitter.addListener(
      DEVICE_EVENTSTORE_EVENT,
      ()=> handler()
    );

    return {
      remove() {
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

  bundleInfo: NativeCalendarManager.bundleInfo

};

export default CalendarManager;
