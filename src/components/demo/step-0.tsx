import React from 'react';
import { motion } from 'framer-motion'
import { styled } from '@stitches/react';
import { Text } from '../text'

const StyledHeading = styled(motion.h2, {
  fontFamily: '$grotesque',
  lineHeight: '1',
  margin: '0',
  fontWeight: 600,
  fontVariantNumeric: 'tabular-nums',
  display: 'block',
  fontSize: '$5xl',
})

const text = `Peek into what's possible`;
const letter = {
  hidden: {
    opacity: 0,
    y: 50
  },
  visible: {
    opacity: 1,
    y: 0,
  }
};
const sentence = {
  hidden: {
    opacity: 0,
  },
  visible: {
    opacity: 1,
    transition: {
      delay: 0.5,
      staggerChildren: 0.08,
    }
  }
};

const Box = styled("div", {
  borderRadius: '$2',
  padding: "$4",
  border: '1px solid $mauve6',
  display: 'flex',
  alignItems: 'center',
})

export const Step0 = () => {
  return (
    <>
      <StyledHeading variants={sentence} initial="hidden" animate="visible">
        {text.split('').map((char, index) => (
          <motion.span key={char + "-" + index} variants={letter}>{char}</motion.span>
        ))}
      </StyledHeading>

      <Box>
        <div style={{ width: 40, height: 40, background: 'gray', marginRight: 16 }} />
        <div>
          <Text size="lg">Kiss</Text>
          <Text>Prince</Text>
        </div>
      </Box>
    </>
  )
}