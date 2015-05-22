'use strict';

var React = require('react-native');

var {
  awSnap
} = require('./helpers.ios.js');

var CalendarManager = require('./calendar-manager.ios.js'),
    SelectRoom = require('./views/select_room.ios.js'),
    LoadingView = require('./views/loading_view.ios.js'),
    RoomView = require('./views/room_view.ios.js');

var DoorSigns2 = React.createClass({
  getInitialState: function() {
    return {
      hasPermission: false,
      selectedCalendarIdentifier: null,
    };
  },
  componentDidMount: function() {
    this.requestPermission();
  },
  requestPermission: function() {
    CalendarManager.requestAccessToCalendarEvents(error => {
      if (error) {
        awSnap(error.message, error.recoverySuggestion, ()=>{});
      } else {
        this.setState({ hasPermission: true });
      }
    });
  },
  render: function() {
    if (!this.state.hasPermission) {
      return (<LoadingView />);
    }

    if (!this.state.selectedCalendarIdentifier) {
      return (
        <SelectRoom onSelectedCalendar={this.selectCalendar} />
      );
    }

    return (
      <RoomView
        calendarIdentifier={this.state.selectedCalendarIdentifier}
        onChangeRoom={this.changeRoom}
      />
    );
  },

  selectCalendar: function(calendarIdentifier) {
    this.setState({
      hasPermission: true,
      selectedCalendarIdentifier: calendarIdentifier
    });
  },

  changeRoom: function() {
    this.setState({
      hasPermission: true,
      selectedCalendarIdentifier: null,
    });
  }
});

module.exports = DoorSigns2;
