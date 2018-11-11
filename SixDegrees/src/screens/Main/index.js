import React, {Component} from 'react';
import {StyleSheet, View, FlatList, Text, Image} from 'react-native';
import { ModalIndicator } from 'teaset';

import Container from '../../components/Container';
import UI from '../../UI';
import Button from '../../components/Button';
import { account, getBalance, getTableRow, deleteCase } from '../../eos';
import OptionsMenu from "react-native-options-menu";
import Bridge from '../../Bridge';

export default class Main extends Component<{}> {

  static navigationOptions = ({ navigation }) => {
    const headerLeft =null;
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

  state = {
    rows:[],
    balance: 0,
    refreshing: false,
  }

  onRefresh= () => {
    this.setState({ refreshing: true });
    getBalance().then(balance => {
      this.setState({ balance })
    })
    getTableRow().then(result => {
      this.setState({ rows: result.rows, refreshing: false });
    });
  }

  componentDidMount() {
    this.onRefresh();
  }

  sharePost = (item) => {
    const rewards = item.reward ? item.reward.split(' ') : ['0', 'EOS'];
    const num = Number(rewards[0]).toString();
    Bridge.sendMessageWithData({ msg: `[Reward ${num}] ${item.desc}`, link: `${account}:${item.id}:0` });
  }


  deletePost = (item) => {
    ModalIndicator.show();
    deleteCase(item.id).then(res => {
      ModalIndicator.hide();
      this.onRefresh();
    }).catch(e=> {
      ModalIndicator.hide();
      Alert.alert('Error', e.message || '');
    })
  }

  cancel = () => {};

  renderItem= (item) =>{
    const rewards = item.item.reward ? item.item.reward.split(' ') : ['0', 'EOS'];
    const num = Number(rewards[0]).toString();
    const reward = num + ' ' + rewards[1];
    if (!!item.item.rewarded) {
      return (
        <View style={styles.item}>
          <View style={styles.row}>
            <View style={styles.rowTextView}>
              <Text style={styles.bountyText}>
                Bounty #{item.item.id}
              </Text>
              <Text
                style={styles.contentText}
                numberOfLines={2}
                ellipsizeMode='tail'
              >
                {item.item.desc}
              </Text>
            </View>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              <Image source={require('../../images/rewarded.png')} style={styles.lineImage}/>
              <Text style={styles.amountText}>
                {reward}
              </Text>
            </View>
          </View>
          <View style={[styles.line, {marginTop: 14,}]} />
        </View>
      )
    };
    return (
      <OptionsMenu
        customButton={
          <View style={styles.item}>
            <View style={styles.row}>
              <View style={styles.rowTextView}>
                <Text style={styles.bountyText}>
                  Bounty #{item.item.id}
                </Text>
                <Text
                  style={styles.contentText}
                  numberOfLines={2}
                  ellipsizeMode='tail'
                >
                  {item.item.desc}
                </Text>
              </View>
              <View style={{flexDirection: 'row', alignItems: 'center'}}>
                <Text style={[styles.amountText,{marginLeft: 12}]}>
                  {reward}
                </Text>
              </View>
            </View>
            <View style={[styles.line, {marginTop: 14,}]} />
          </View>
        }
        buttonStyle={styles.item}
        destructiveIndex={1}
        options={["Share", "Delete", "Cancel"]}
        actions={[() =>this.sharePost(item.item), ()=>this.deletePost(item.item), this.cancel]}
      />
    )
  }

  render() {
    return (
      <Container>
        <View style={styles.headerView}>
          <View style={styles.textView}>
            <Text style={styles.titleText}>{account}</Text>
            <Text style={styles.balanceText}>Balance: {this.state.balance} EOS</Text>
          </View>
          <View style={styles.imageView}>
            <Image
              style={styles.image}
              source={require('../../images/ic-EOS.png')}
            />
          </View>
        </View>
        <FlatList
          style={{ flex: 1, }}
          containerStyle={{ paddingBottom: 20 }}
          refreshing={this.state.refreshing}
          onRefresh={this.onRefresh}
          keyExtractor={item => item.id && item.id.toString()}
          data={this.state.rows || []}
          renderItem={this.renderItem}
        />
        <View style={{height: 75, paddingTop: 10,}}>
          <Button
            type='small'
            name='New'
            onPress={() => {
              this.props.navigation.navigate('newTask',{
                onNewCaseCreated: this.onRefresh,
              })
            }}
          />
        </View>
      </Container>
    );
  }
}

const styles = StyleSheet.create({
  headerView: {
    paddingTop: 10,
    paddingBottom: 24,
    height: 106,
    flexDirection: 'row',
    marginHorizontal: UI.unit * 4,
  },
  textView: {
    flex: 1,
  },
  titleText: {
    fontFamily: 'Menlo-Bold',
    fontSize: 30,
    color: UI.color.black,
    fontWeight: '600',
  },
  balanceText: {
    fontSize: 16,
    color: UI.color.black1,
    marginTop: 12,
  },
  imageView: {
    borderRadius: 12,
    overflow:'hidden',
  },
  image: {
    width: 72,
    height: 72,
  },
  item: {
    paddingHorizontal: UI.unit * 4,
  },
  row: {
    flexDirection: 'row',
    height: 92,
    paddingTop: 14,
    alignItems: 'center',
  },
  rowTextView: {
    flex: 1,
  },
  bountyText: {
    fontSize: 12,
    color: UI.color.gray9,
  },
  contentText: {
    fontSize: 16,
    color: UI.color.black,
    marginTop: 8,
  },
  amountText: {
    fontSize: 20,
    color: UI.color.black1,
    fontWeight: '500',
  },
  line: {
    borderColor: UI.color.border,
    borderBottomWidth: 1,
  },
  lineImage: {
    width: 16,
    height: 16,
    borderRadius: 8,
    marginRight: 6,
    marginLeft: 18,
  },
});
