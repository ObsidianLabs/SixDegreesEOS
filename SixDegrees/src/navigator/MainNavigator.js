import { createStackNavigator } from 'react-navigation';

import Main from '../screens/Main'
import NewTaskScreen from '../screens/Main/NewTaskScreen'

export default createStackNavigator(
  {
    main: Main,
    newTask: NewTaskScreen,
  },
);