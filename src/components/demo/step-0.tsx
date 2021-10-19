import React from 'react';
import { styled } from '@stitches/react';
import { Text } from '../text'

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
      <Box>
        <div style={{ width: 40, height: 40, background: 'gray', marginRight: 16 }} />
        <div>
          <Text size="lg" fontWeight={600}>Kiss</Text>
          <Text>Prince</Text>
        </div>
      </Box>
    </>
  )
}