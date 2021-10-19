import React from 'react';
import { styled } from '@stitches/react';
import { Text } from '../text'
import { SpeakerLoudIcon } from '@radix-ui/react-icons';

const Box = styled("div", {
  borderRadius: '$2',
  padding: "$4",
  border: '1px solid $mauve6',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
})

export const Step0 = () => {
  return (
    <>
      <Box>
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <img src="https://upload.wikimedia.org/wikipedia/en/d/d8/Prince_kiss.jpg" style={{ width: 40, height: 40, backgroundColor: 'gray', marginRight: 16, borderRadius: 6 }} />
          <div style={{ height: "100%", display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <Text size="lg" fontWeight={700} color="primary">Kiss</Text>
            <Text size="md" fontWeight={400}>Prince</Text>
          </div>
        </div>
        <SpeakerLoudIcon />
      </Box>
    </>
  )
}