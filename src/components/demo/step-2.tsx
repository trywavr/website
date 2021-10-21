import React from 'react';
import { SpeakerLoudIcon, SpeakerOffIcon } from '@radix-ui/react-icons';
import { Text } from '../text';
import { styled } from '@stitches/react';
import { motion } from 'framer-motion';

const instruments = [
  'Grand Piano',
  'Retro Synthesizer',
  'Acoustic Guitar',
  'Bass Drum',
];

const InstrumentCard = styled(motion.li, {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  borderRadius: '$2',
  padding: '$4',
  marginBottom: '16px',
  variants: {
    toggle: {
      on: {
        border: '1px solid $mauve9',
        color: '$mauve12',
        boxShadow: '0 0 16px 0 $colors$violetA9',
      },
      off: {
        border: '1px solid $mauve6',
        color: '$mauve11',
      },
    },
  },
  defaultVariants: {
    toggle: 'off',
  },
});

const Instrument = ({ instrument }: { instrument: string }) => {
  const [toggle, setToggle] = React.useState(false);

  const listItem = {
    hidden: { opacity: 0, x: -50 },
    show: { opacity: 1, x: 0 }
  };
  return (
    <InstrumentCard
      onClick={() => setToggle(!toggle)}
      toggle={toggle === true ? 'on' : 'off'}
      variants={listItem}
    >
      <Text color="inherit">{instrument}</Text>
      {toggle ? <SpeakerLoudIcon /> : <SpeakerOffIcon />}
    </InstrumentCard>
  );
};

export const Step2 = () => {
  const container = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        staggerChildren: 0.5
      }
    }
  };


  return (
    <motion.ul
      style={{ padding: 0 }}
      variants={container}
      initial="hidden"
      animate="show"
    >
      {instruments.map(instrument => (
        <Instrument key={instrument} instrument={instrument} />
      ))}
    </motion.ul>
  );
};
