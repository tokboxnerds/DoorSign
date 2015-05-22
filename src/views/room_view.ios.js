/*global require, fetch, setInterval, clearInterval*/
/*jshint -W097, esnext:true */

'use strict';

var React = require('react-native');
var {
  Image,
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
} = React;

var {
  awSnap
} = require('../helpers.ios.js');

var LoadingView = require('./loading_view.ios.js'),
    CalendarManager = require('../calendar-manager.ios.js');

var styles = StyleSheet.create({

  roomContainer: {
    flex: 1,
    top: 0,
    bottom: 0,
    left: 0,
    right: 0
  },

  floor: {
    bottom: 0,
    backgroundColor: '#1186C1',
    justifyContent: 'center',
    alignItems: 'center'
  },

  roomIcon: {
    height: 113,
    width: 209,
    marginBottom: 10,
    marginTop: 10,
    backgroundColor: 'red'
  },

  eventDisplayContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#04243B',
  },

  available: {
    fontFamily: 'Avenir Next',
    fontWeight: 'bold',
    fontSize: 114,
    color: '#ffffff',
    textAlign: 'center',
  },

  moreInfo: {
    fontFamily: 'Avenir Next',
    fontWeight: 'normal',
    fontSize: 72,
    color: '#ffffff',
    textAlign: 'center',
  },

  eventTime: {
    fontFamily: 'Avenir',
    fontSize: 36,
    color: '#ffffff',
    textAlign: 'center',
  }

});

var roomIcons = {
  "Gold Rush": require('image!GoldRush'),
  "Calendar": require('image!GoldRush'),
};

class Room extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loaded: false,
      calendarName: null,
      currentEvents: [],
      todaysEvents: [],
    };
  }

  componentDidMount() {
    this.eventStoreChanged = CalendarManager.addEventListener('eventStoreChanged',
      ()=> this.fetchData() );
    this.fetchData();
    this.timeProgressesInterval = setInterval(() => { this.fetchData(); }, 30 * 1000);
  }

  componentWillUnmount() {
    this.eventStoreChanged.remove();
    clearInterval(this.timeProgressesInterval);
  }

  fetchData() {
    this.fetchName(calendarName => {
      this.fetchCurrentEvents(currentEvents => {
        this.fetchTodaysEvents(todaysEvents => {
          this.setState({
            loaded: true,
            calendarName: calendarName,
            currentEvents: currentEvents,
            todaysEvents: todaysEvents,
          });
        });
      });
    });
  }

  fetchName(andThen) {
    CalendarManager.calendarNameForIdentifier(this.props.calendarIdentifier, (err, calendarName) => {
      if (err) {
        awSnap(err.message, err.recoverySuggestion, ()=>{});
      }
      andThen(calendarName);
    });
  }

  fetchCurrentEvents(andThen) {
    CalendarManager.currentEventsInCalendar(this.props.calendarIdentifier, (err, currentEvents) => {
      if (err) {
        awSnap(err.message, err.recoverySuggestion, ()=>{});
      }
      andThen(currentEvents);
    });
  }

  fetchTodaysEvents(andThen) {
    CalendarManager.todaysUpcomingEventsInCalendar(this.props.calendarIdentifier, (err, todaysEvents) => {
      if (err) {
        awSnap(err.message, err.recoverySuggestion, ()=>{});
      }
      andThen(todaysEvents);
    });
  }


  render() {

    if (!this.state.loaded) {
      return (<LoadingView />);
    }

    var eventDisplay;

    // if in conflict
    if (this.state.currentEvents.length > 1) {
      eventDisplay = (<Text>Oops! Conflicts!</Text>);

    // if in use
    } else if (this.state.currentEvents.length === 1) {

      var event = this.state.currentEvents[0];

      eventDisplay = (
        <View>
          <Text style={styles.available}>In use</Text>
          <Text style={styles.moreInfo}>{event.title}</Text>
          <Text style={styles.eventTime}>Ends at {event.endsAtPretty}</Text>
        </View>
      );

    // if in use later
    } else if (this.state.todaysEvents.length > 0) {

      // EKEvent *nextEvent = upcomingEvents.firstObject;
      var nextEvent = this.state.todaysEvents[0];

      // self.roomStatus.text = @"Available";
      var roomStatus = "Available";

      // NSTimeInterval interval = [nextEvent.startDate timeIntervalSinceNow] / 60;
      var interval = (nextEvent.startsAt - Date.now()) / 60000;

      var availableForTime = "";

      if(interval > 60) {
        availableForTime = "";

      } else if(interval > 55) {
        availableForTime = "For an hour";

      } else if(interval > 50) {
        availableForTime = "For 50 minutes";

      } else if(interval > 45) {
        availableForTime = "For 45 minutes";

      } else if(interval > 40) {
        availableForTime = "For 40 minutes";

      } else if(interval > 35) {
        availableForTime = "For 35 minutes";

      } else if(interval > 30) {
        availableForTime = "For 30 minutes";

      } else if(interval > 25) {
        availableForTime = "For 25 minutes";

      } else if(interval > 20) {
        availableForTime = "For 20 minutes";

      } else if(interval > 15) {
        availableForTime = "For 15 minutes";

      } else if(interval > 10) {
        availableForTime = "For ten minutes";

      } else if(interval > 5) {
        availableForTime = "For five minutes";

      } else {
        roomStatus = "In use";
        availableForTime = "Very soon";
      }

      eventDisplay = (
        <View>
          <Text style={styles.available}>{roomStatus}</Text>
          <Text style={styles.moreInfo}>{availableForTime}</Text>
          <Text style={styles.eventTime}>{nextEvent.title} at {nextEvent.startsAtPretty}</Text>
        </View>
      );

    // if available
    } else {
      eventDisplay = (<Text style={styles.available}>Available</Text>);
    }

    return (
      <View style={styles.roomContainer}>
        <View style={styles.eventDisplayContainer}>
          {eventDisplay}
        </View>
        <View style={styles.floor}>
          <TouchableHighlight
            underlayColor="#146BA8"
            onPress={this.onPressChangeRoom.bind(this)}>
              <Image source={roomIcons[this.state.calendarName]} style={styles.roomIcon} />
          </TouchableHighlight>
        </View>
      </View>
    );
  }

  onPressChangeRoom() {
    this.props.onChangeRoom();
  }
}



module.exports = Room;
