import React, {Component} from 'react';
import {StyleSheet, Text, View, TextInput, Alert, KeyboardAvoidingView} from 'react-native';

import { HeaderLeft } from '../../components/Headers';
import H2 from '../../components/H2';
import Container from '../../components/Container';
import Button from '../../components/Button';
import UI from '../../UI';
import { Overlay, ModalIndicator } from 'teaset';
import PullViewContainer from '../../components/PullViewContainer';
import { newCase } from '../../eos';

export default class NewTaskScreen extends Component<{}> {

  static navigationOptions = ({ navigation }) => {
    const headerLeft = (
      <HeaderLeft
        navigation={navigation}
      />
    );
    const headerStyle = {
      backgroundColor: UI.color.white1,
      borderBottomWidth: 0,
      shadowRadius: 0,
      shadowOpacity: 0,
      shadowOffset: {
        height: 0,
        width: 0,
      },
      elevation: 0,
    };
    return { headerLeft, headerStyle };
  };

  parseEosError(error) {
    let errorMessage = error.message;
    if (typeof error === 'string') {
      try {
        const errorObj = JSON.parse(error);
        errorMessage = errorObj.error.details.map(d => d.message).join('; ');
      } catch (_) {}
    }
    return errorMessage;
  };

  onCreate=  async () => {
    const { onNewCaseCreated} = this.props.navigation.state.params;
    if (!this.task) {
      Alert.alert('Please enter the task.');
      return;
    }
    if (!this.reward) {
      Alert.alert('Please enter the reward amount.');
      return;
    }
    let res;
    this.overlay && this.overlay.close();
    ModalIndicator.show();
    try {
      res =  await newCase(Number(this.reward), this.task);
    } catch (e) {
      const errorMessage = this.parseEosError(e);
      ModalIndicator.hide();
      Alert.alert('Error', errorMessage || '');
      return;
    }
    ModalIndicator.hide();
    this.props.navigation.goBack();
    onNewCaseCreated();
  }

  showPullView = () => {
    if (!this.task) {
      Alert.alert('Please enter the task');
      return;
    }
    if (!this.reward) {
      Alert.alert('Please enter the reward');
      return;
    }
    const overlayView = (
      <Overlay.PullView
        ref={v => (this.overlay = v)}
        containerStyle={{
          borderTopLeftRadius: 12,
          borderTopRightRadius: 12,
          overflow: 'hidden',
        }}
        side="bottom"
      >
        <PullViewContainer
          title="Create New Bounty"
          onPress={()=>{this.overlay && this.overlay.close()}}
        >
          <View style={{ flex: 1, paddingBottom: 20 }}>
            <View style={styles.valueView}>
              <Text style={styles.valueText}>
                {this.reward} EOS
              </Text>
            </View>
            <View style={{flex: 1, paddingHorizontal: UI.unit * 4, marginTop: 12}}>
              <Text style={UI.font.regular} numberOfLines={3}>{this.task}</Text>
            </View>
          </View>
          <Button
            type="small"
            name='Create'
            onPress={this.onCreate}
          />
          <View style={{height: 20}}/>
        </PullViewContainer>
      </Overlay.PullView>
    );
    const key = Overlay.show(overlayView);
  }

  reward = '100';
  task = 'Block.one is looking for a proficient C++ developers. If you know anybody who is interested, please let us know.';

  render() {

    return (
      <KeyboardAvoidingView
        keyboardVerticalOffset={UI.IS_IPHONE_X ? 24 : 0}
        behavior="padding"
        style={{ flex: 1, backgroundColor: UI.color.bg1 }}
      >
        <Container scroll>
          <View style={styles.titleView}>
            <H2 topless>New Bounty</H2>
          </View>

          <View style={{marginHorizontal: UI.unit * 4,}}>
            <Text
              style={{fontSize: 12, color: UI.color.gray9, marginTop: 36,}}
            >
              Bounty description
            </Text>

            <TextInput
              autoCapitalize="none"
              autoCorrect={false}
              underlineColorAndroid="transparent"
              multiline
              enablesReturnKeyAutomatically
              returnKeyType="done"
              textAlignVertical="top"
              style={styles.textInput}
              defaultValue="Block.one is looking for a proficient C++ developers. If you know anybody who is interested, please let us know."
              onChangeText={text => {
                this.task = text.trim();
              }}
            />

            <View style={[styles.line, {marginTop: 18,}]} />

            <Text
              style={{fontSize: 12, color: UI.color.gray9, marginTop: 18,}}
            >
              Reward
            </Text>

            <View style={{flexDirection: 'row-reverse', marginTop: 12,}}>
              <Text
                style={{fontSize: 16, color: UI.color.gray9, textAlign: 'right', marginLeft: 5,}}
              >
                EOS
              </Text>

              <TextInput
                keyboardType='numeric'
                autoCapitalize="none"
                autoCorrect={false}
                underlineColorAndroid="transparent"
                enablesReturnKeyAutomatically
                returnKeyType="done"
                defaultValue="100"
                onChangeText={text => {
                  this.reward = text.trim();
                }}
                style={{flex: 1, fontSize: 16, color: UI.color.black, padding: 0,}}
              />
            </View>
          </View>
          <View style={[styles.line, {marginTop: 18, marginBottom: 22, marginHorizontal: UI.unit * 4}]} />
          <Button
            type='small'
            name='Create'
            onPress={this.showPullView}
          />
        </Container>
      </KeyboardAvoidingView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  button: {
    width: 100,
    height: 32,
    backgroundColor: 'red',
    alignItems: 'center',
    justifyContent: 'center',
  },
  opationButton: {
    height: UI.unit * 8,
    borderRadius: 12,
    marginHorizontal: UI.unit * 4,
    flexDirection: 'row',
    backgroundColor: UI.color.primary1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  valueView: {
    paddingHorizontal: UI.unit * 4,
    height: 120,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderColor: UI.color.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  valueText: {
    ...UI.font.whiteRobotRegular16,
    fontSize: UI.fontSize.big,
    color: UI.color.black,
    fontWeight: '500',
  },
  titleView: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  line: {
    borderColor: UI.color.border,
    borderBottomWidth: 1,
  },
  textInput: {
    fontSize: 16,
    color: UI.color.black,
    marginTop: 12,
    height: 80,
    padding: 0,
  },
  opationButtonText: {
    fontFamily: 'Avenir Next',
    fontWeight: '500',
    fontSize: 16,
    lineHeight: 24,
    height: 24,
    color: UI.color.white1,
  },
  titleText: {
    width: 60,
    backgroundColor: 'red',
  },
  lineRight: {
    flex:3 ,
    flexDirection: 'row',
    alignItems: 'center',
  },
  itemReceipentText: {
    flex: 1,
  }
});
