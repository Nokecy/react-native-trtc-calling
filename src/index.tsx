import { NativeModules } from 'react-native';

type TrtcCallingType = {
  multiply(a: number, b: number): Promise<number>;
};

const { TrtcCalling } = NativeModules;

export default TrtcCalling as TrtcCallingType;
