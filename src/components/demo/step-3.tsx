import React from 'react';
import { Checkbox, Radio, RadioGroup, Slider } from '@components/index';

export const Step3 = () => {
  return (
    <>
      <Slider defaultValue={[10]} max={50} />
      <div style={{ display: 'flex', flexDirection: 'row', gap: 16, margin: "16px 0" }}>
        <Checkbox size="2" />
        <Checkbox size="2" />
        <Checkbox size="2" />
      </div>
      <RadioGroup defaultValue="happy">
        <Radio value="hello" size="2" />
        <Radio value="happy" size="2" />
        <Radio value="halloween" size="2" />
      </RadioGroup>
    </>
  );
};
