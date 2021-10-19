import React from 'react';
import { motion } from 'framer-motion'
import { styled } from '@stitches/react';

const StyledHeading = styled(motion.h2, {
  fontFamily: '$grotesque',
  lineHeight: '1',
  margin: '0 0 64px 0',
  fontWeight: 600,
  fontVariantNumeric: 'tabular-nums',
  display: 'block',
  fontSize: '$5xl',
})
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

export const AnimatedHeading = ({ text }: { text: string }) => (
  <StyledHeading variants={sentence} initial="hidden" animate="visible">
    {text.split('').map((char, index) => (
      <motion.span key={char + "-" + index} variants={letter}>{char}</motion.span>
    ))}
  </StyledHeading>
)