
import { AlertIOS } from 'react-native';

export function awSnap(message, recoverySuggestion, onPress) {
  AlertIOS.alert(
    message,
    recoverySuggestion,
    [{text: 'Oh snap!', onPress: onPress}]
  );
}
