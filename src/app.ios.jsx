import React from 'react-native';

import { awSnap } from './helpers.ios';

import CalendarManager from './calendar-manager.ios';
import SelectRoom from './views/select_room.ios';
import LoadingView from './views/loading_view.ios';
import RoomView from './views/room_view.ios';

export default React.createClass({

  name: 'DoorSigns2',

  getInitialState: function() {
    return {
      hasPermission: false,
      bundleInfo: null,
      selectedCalendarIdentifier: null,
    };
  },
  componentDidMount: function() {
    this.requestPermission();
    this.getBundleInfo();
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

  getBundleInfo: function() {
    CalendarManager.bundleInfo(info => this.setState({ bundleInfo: info }) );
  },

  render: function() {
    if (!this.state.hasPermission || !this.state.bundleInfo) {
      return (<LoadingView />);
    }

    if (!this.state.selectedCalendarIdentifier) {
      return (
        <SelectRoom onSelectedCalendar={this.selectCalendar} bundleInfo={this.state.bundleInfo}/>
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
