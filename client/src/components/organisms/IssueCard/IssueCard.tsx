import React, { FunctionComponent } from 'react';
import IssueInfo from '@components/molecules/IssueInfo';
import { IssueOpenedIcon, IssueClosedIcon } from '@components/atoms/icons';
import styled from '@themes/styled';
import Assignees from '@components/molecules/Assignees';
import { User } from '@stores/type';
import { Label } from '@components/atoms/LabelTag';

interface Props {
  isOpen: 1 | 0;
  title: string;
  labels?: Label[];
  issueNum: number;
  time: string;
  author: string;
  milestone?: string;
  assignees?: User[];
}

const StyledIssueCard = styled.div`
  display: flex;
  box-sizing: border-box;
  & > input {
    margin: 11px 0px 8px 16px;
  }
`;

const IssueCard: FunctionComponent<Props> = ({
  isOpen,
  title,
  labels,
  issueNum,
  time,
  author,
  milestone,
  assignees,
}) => (
  <StyledIssueCard>
    <input type="checkbox" />
    {isOpen ? <IssueOpenedIcon /> : <IssueClosedIcon />}
    <IssueInfo
      isOpen={isOpen}
      title={title}
      labels={labels}
      issueNum={issueNum}
      time={time}
      author={author}
      milestone={milestone}
    />
    <Assignees users={assignees} />
  </StyledIssueCard>
);

export default IssueCard;
