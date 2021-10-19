import React from 'react';
import { SpeakerLoudIcon, SpeakerOffIcon } from '@radix-ui/react-icons';
import { Text } from '../text';
import { styled } from '@stitches/react';

const instruments = [
  'Grand Piano',
  'Retro Synthesizer',
  'Acoustic Guitar',
  'Bass Drum',
];

const InstrumentCard = styled('div', {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  borderRadius: '$2',
  padding: "$4",
  marginBottom: "16px",
  variants: {
    toggle: {
      on: {
        border: '1px solid $mauve9',
        color: "$mauve12",
        boxShadow: "0 0 16px 0 $colors$violetA9",
      },
      off: {
        border: '1px solid $mauve6',
        color: "$mauve11"
      }
    },
  },
  defaultVariants: {
    toggle: "off"
  }
})

const Instrument = ({ instrument }: { instrument: string }) => {
  const [toggle, setToggle] = React.useState(false);
  return (
    <InstrumentCard
      onClick={() => setToggle(!toggle)}
      toggle={toggle === true ? "on" : "off"}
    >
      <Text color="inherit">{instrument}</Text>
      {toggle ? <SpeakerLoudIcon /> : <SpeakerOffIcon />}
    </InstrumentCard>
  );
};

export const Step2 = () => {
  return (
    <>
      {instruments.map(instrument => (
        <Instrument key={instrument} instrument={instrument} />
      ))}
    </>
  );
};
