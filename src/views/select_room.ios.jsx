/*global require, fetch, setInterval, clearInterval*/
/*jshint -W097, esnext:true */

import React, {
  ListView,
  StyleSheet,
  Text,
  TouchableHighlight,
  View
} from 'react-native';

import { awSnap } from '../helpers.ios';
import LoadingView from './loading_view.ios';
import CalendarManager from '../calendar-manager.ios';
import RoomIcons from '../room_icons.ios.jsx';

const styles = StyleSheet.create({

  listViewContainer: {
    flex: 1,
    backgroundColor: '#146BA8',
  },

  listViewHeader: {
    marginTop: 100,
    marginLeft: 100,
    marginRight: 100,
    marginBottom: 8,
    textAlign: 'center',
    fontFamily: 'Avenir',
    fontSize: 36,
    color: '#ffffff',
  },

  listViewFooter: {
    marginTop: 8,
    marginLeft: 100,
    marginRight: 100,
    marginBottom: 100,
    textAlign: 'center',
    fontFamily: 'Avenir',
    fontSize: 18,
    color: 'rgba(255,255,255,0.5)',
  },

  listView: {
    paddingLeft: 100,
    paddingRight: 100,
    backgroundColor: '#04243B',
  },

  calendarName: {
    marginLeft: 16,
    marginTop: 16,
    marginRight: 16,
    marginBottom: 16,
    textAlign: 'left',
    color: '#ffffff',
    fontFamily: 'Avenir',
    fontSize: 24,
  },

});

export default React.createClass({
  name: 'SelectRoom',

  getInitialState: function () {
      return {
        dataSource: new ListView.DataSource({
          rowHasChanged: (row1, row2) => row1 !== row2,
        }),
        loaded: false,
      };
  },
  componentDidMount: function () {
    this.eventStoreChanged = CalendarManager.addEventListener('eventStoreChanged', this.fetchData);
    this.fetchData();
  },
  componentWillUnmount: function() {
    this.eventStoreChanged.remove();
  },
  fetchData: function() {
    CalendarManager.calendarNames((err, calendarNames) => {
      if (err) {
        awSnap(err.message, err.recoverySuggestion, ()=>{});
      }

      const dataSource = calendarNames.filter( calendar => RoomIcons[calendar.title] != null);

      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(dataSource),
        loaded: true,
      });
    });
  },
  render: function() {
    if (!this.state.loaded) {
      return (<LoadingView />);
    }

    const {
      CFBundleDisplayName,
      CFBundleShortVersionString,
      CFBundleVersion
    } = this.props.bundleInfo;

    return (
      <View style={styles.listViewContainer}>
        <Text style={styles.listViewHeader}>Select Calendar</Text>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this.renderCalendar}
          style={styles.listView}
        />
        <Text style={styles.listViewFooter}>
          {CFBundleDisplayName} v{CFBundleShortVersionString} ({CFBundleVersion}). 👋 from Sydney.
        </Text>
      </View>
    );
  },
  renderCalendar: function(calendar) {
    return (
      <SelectableCalendar
        title={calendar.title}
        calendarIdentifier={calendar.calendarIdentifier}
        onSelected={this.onCalendarSelected}
      ></SelectableCalendar>
    );
  },
  onCalendarSelected: function(calendarIdentifier) {
    this.props.onSelectedCalendar(calendarIdentifier);
  }
});

class SelectableCalendar extends React.Component {
  render() {
    return (
      <TouchableHighlight
        underlayColor="#146BA8"
        onPress={this.onPress.bind(this)}>
        <View>
          <Text style={styles.calendarName}>{this.props.title}</Text>
        </View>
      </TouchableHighlight>
    );
  }

  onPress() {
    this.props.onSelected(this.props.calendarIdentifier);
  }
}
