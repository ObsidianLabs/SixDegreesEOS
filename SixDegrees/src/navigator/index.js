import React from 'react';
import { createSwitchNavigator } from 'react-navigation';

import MainNavigator from './MainNavigator';
import SplashScreen from '../screens/SplashScreen';

export default RootNavigator = createSwitchNavigator({
  splash: SplashScreen,
  main: {
    screen: ({ navigation }) => (
      <MainNavigator
        screenProps={{
          rootNavigation: navigation,
        }}
      />
    ),
  },
});